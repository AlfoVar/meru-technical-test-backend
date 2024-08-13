class Users::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    user = User.find_by(email: params[:user][:email])

    if user&.valid_password?(params[:user][:password])
      token = AuthenticationService.new(user).generate_jwt
      render json: { message: 'Logged in successfully.', token: token, user: user }, status: :ok
    else
      render json: { message: 'Invalid email or password.' }, status: :unauthorized
    end
  end

  def destroy
    begin
      authorization_header = request.headers['Authorization']
      Rails.logger.debug "Authorization Header: #{authorization_header}"

      if authorization_header.present?
        jwt_token = authorization_header.split(' ').last
        Rails.logger.debug "JWT Token: #{jwt_token}"

        jwt_payload = JWT.decode(jwt_token, Rails.application.credentials.devise[:jwt_secret_key]).first
        jti = jwt_payload['jti']
        Rails.logger.debug "JWT Payload: #{jwt_payload}"

        if current_user.jti == jti
          current_user.update(jti: nil)
          render json: { message: 'Logged out successfully.' }, status: :ok
        else
          render json: { error: 'Invalid token.' }, status: :unauthorized
        end
      else
        render json: { error: 'Authorization header missing.' }, status: :unauthorized
      end
    rescue JWT::DecodeError => e
      Rails.logger.error "JWT Decode Error: #{e.message}"
      render json: { error: 'Invalid token.' }, status: :unauthorized
    end
  end
end