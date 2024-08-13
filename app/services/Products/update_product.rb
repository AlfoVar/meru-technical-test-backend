module Products
    class UpdateProduct
      def initialize(product, params)
        @product = product
        @params = params
      end
  
      def call
        return @product unless valid_params?
  
        @product.update(@params)
        @product
      end
  
      private
  
      def valid_params?
        @params[:name].present? && @params[:description].present? && @params[:price].present?
      end
    end
  end