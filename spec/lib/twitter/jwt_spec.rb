require 'rails_helper'
require 'twitter/jwt'

RSpec.describe(Twitter::JWT) do
  describe('.token') do
    it 'provides a method to get a token' do
      VCR.use_cassette('twitter/jwt') do
        expect(described_class.token).to eql('Bearer very-long-string')
      end
    end
  end

  context('when authentication is incorrect') do
    it 'returns false' do
      VCR.use_cassette('twitter/jwt-invalid-credentials') do
        expect(described_class.token).to eql(false)
      end
    end

    it 'provides an error message' do
      VCR.use_cassette('twitter/jwt-invalid-credentials') do
        subject = described_class.new

        subject.token

        expect(subject.error).to eql(
          '{"errors":[{"code":99,"message":"Unable to verify your credentials"'\
            ',"label":"authenticity_token_error"}]}'
        )
      end
    end
  end

  context('when environment variables are missing') do
    it 'throws an exception when TWITTER_API_KEY is not set' do
      api_key = ENV.delete('TWITTER_API_KEY')
      message = 'Set TWITTER_API_KEY in the .env file'

      expect do
        described_class.token
      end.to raise_error(ArgumentError, message)

      ENV['TWITTER_API_KEY'] = api_key
    end

    it 'throws an exception when TWITTER_API_SECRET is not set' do
      api_secret = ENV.delete('TWITTER_API_SECRET')
      message = 'Set TWITTER_API_SECRET in the .env file'

      expect { described_class.token }.to raise_error(ArgumentError, message)

      ENV['TWITTER_API_SECRET'] = api_secret
    end

    it 'throws an exception when TWITTER_HOST is not set' do
      host = ENV.delete('TWITTER_HOST')
      message = 'Set TWITTER_HOST in the .env file'

      expect { described_class.token }.to raise_error(ArgumentError, message)

      ENV['TWITTER_HOST'] = host
    end
  end
end
