require 'rails_helper'

RSpec.describe AuthenticationService, type: :service do
  let(:user) { create(:user) }
  let(:service) { described_class.new(user) }
  let(:token) { service.generate_jwt }

  describe '#generate_jwt' do
    it 'Generar un JWT valido' do
      expect(token).not_to be_nil
      decoded_token = JWT.decode(token, Rails.application.credentials.devise[:jwt_secret_key], true, { algorithm: 'HS256' })
      expect(decoded_token[0]['user_id']).to eq(user.id)
    end
  end

  describe '.decode_jwt' do
    it 'decodes a valid JWT token' do
      user_id = described_class.decode_jwt(token)
      expect(user_id).to eq(user.id)
    end

    it 'returns nil for an invalid JWT token' do
      invalid_token = 'invalid.token.here'
      user_id = described_class.decode_jwt(invalid_token)
      expect(user_id).to be_nil
    end
  end
end