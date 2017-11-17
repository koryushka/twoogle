module Twitter
  class JWT
    attr_reader :error

    GRANT_TYPE = 'client_credentials'.freeze

    def self.token
      new.token
    end

    def token
      if (200...300).cover?(request.code)
        auth_token_from_response
      else
        self.error = request.body
        false
      end
    end

    private

    attr_writer :error

    def access_token
      JSON.parse(request.body)['access_token']
    end

    def api_key
      ENV.fetch('TWITTER_API_KEY') do
        fail(ArgumentError, 'Set TWITTER_API_KEY in the .env file')
      end
    end

    def api_secret
      ENV.fetch('TWITTER_API_SECRET') do
        fail(ArgumentError, 'Set TWITTER_API_SECRET in the .env file')
      end
    end

    def auth_token_from_response
      "Bearer #{access_token}"
    end

    def body
      { grant_type: grant_type }
    end

    def encoded_token
      string_to_encode = "#{api_key}:#{api_secret}"
      encoded_string = Base64.strict_encode64(string_to_encode)
      "Basic #{encoded_string}"
    end

    def grant_type
      GRANT_TYPE
    end

    def headers
      {
        'Content-Type' => 'application/x-www-form-urlencoded;charset=UTF-8',
        'Authorization' => encoded_token
      }
    end

    def host
      ENV.fetch('TWITTER_HOST') do
        fail(ArgumentError, 'Set TWITTER_HOST in the .env file')
      end
    end

    def request
      @request ||= HTTParty.post(url, body: body, headers: headers)
    end

    def url
      "#{host}/oauth2/token"
    end
  end
end
