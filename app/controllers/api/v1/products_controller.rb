class Api::V1::ProductsController < ApplicationController
    before_action :authenticate_user!, only: [:create]
  
    def index
        @products = Product.all
        render json: @products
      end
    
      def show
        @product = Products::GetProduct.new(params[:id]).call
        render json: @product
      end
    
      def create
        result = Products::CreateProduct.new(product_params).call
        if result[:success]
          @product = result[:product]
          render json: @product, status: :created
        else
          render json: result[:errors], status: :unprocessable_entity
        end
      end
    
      def update
        @product = Products::GetProduct.new(params[:id]).call
        update_product = Products::UpdateProduct.new(@product, product_params).call
        render json: update_product
      end
    
      def destroy
        @product = Products::GetProduct.new(params[:id]).call
        Products::DeleteProduct.new(@product).call
        head :no_content
      end
  
    private
  
    def authenticate_user!
        authorization_header = request.headers['Authorization']
        Rails.logger.debug "Authorization Header in authenticate_user!: #{authorization_header}"
    
        unless verify_jwt_token
          render json: { error: 'You need to sign in or sign up before continuing.' }, status: :unauthorized
        end
      end
    
      def product_params
        params.require(:product).permit(:name, :description, :price)
      end
    
      def verify_jwt_token
        authorization_header = request.headers['Authorization']
        Rails.logger.debug "Authorization Header in verify_jwt_token: #{authorization_header}"
    
        if authorization_header.present?
          jwt_token = authorization_header.split(' ').last
          Rails.logger.debug "JWT Token: #{jwt_token}"
    
          begin
            jwt_payload = JWT.decode(jwt_token, Rails.application.credentials.devise[:jwt_secret_key]).first
            Rails.logger.debug "JWT Payload: #{jwt_payload}"
            @current_user = User.find(jwt_payload['user_id'])
            return true
          rescue JWT::DecodeError => e
            Rails.logger.error "JWT Decode Error: #{e.message}"
            render json: { error: 'Invalid token.' }, status: :unauthorized
            return false
          end
        else
          render json: { error: 'Authorization header missing.' }, status: :unauthorized
          return false
        end
      end
    
      def user_signed_in?
        @current_user.present?
      end
  end