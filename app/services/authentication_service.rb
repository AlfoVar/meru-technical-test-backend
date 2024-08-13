class AuthenticationService
    def initialize(user)
      @user = user
    end
  
    def generate_jwt
      exp = 24.hours.from_now.to_i
      payload = { user_id: @user.id, exp: exp, jti: SecureRandom.uuid }
      JWT.encode(payload, Rails.application.credentials.devise[:jwt_secret_key])
    end
  
    def self.decode_jwt(token)
      decoded_token = JWT.decode(token, Rails.application.credentials.devise[:jwt_secret_key], true, { algorithm: 'HS256' })
      decoded_token[0]['user_id']
    rescue JWT::DecodeError
      nil
    end
end