class Users::RegistrationsController < Devise::RegistrationsController
    respond_to :json
  
    def create
      user = User.new(sign_up_params)
      if user.save
        token = AuthenticationService.new(user).generate_jwt
        render json: { message: 'Signed up successfully.', user: user, token: token }, status: :ok
      else
        render json: { message: 'Something went wrong.', errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    private
  
    def sign_up_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
  end