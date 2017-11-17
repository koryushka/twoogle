require 'twitter/jwt'

module Twitter
  class Searcher
    attr_reader :search_term, :error

    PATH = '1.1/search/tweets.json'.freeze

    def initialize(search_term:)
      self.search_term = search_term
    end

    def search
      if successful?
        tweets_from_response
      else
        process_error
      end
    end

    def successful?
      (200...300).cover?(request.code)
    end

    private

    attr_writer :search_term, :error

    def process_error
      self.error = parsed_error
      Rails.logger.error("[Twitter]: search error - #{error}")
      false
    end

    def parsed_error
      JSON.parse(request.body)['errors'].first['message']
    end

    def tweets_from_response
      JSON.parse(request.body).fetch('statuses', [])
    end

    def headers
      { 'Authorization' => jwt_token.to_s }
    end

    def host
      ENV.fetch('TWITTER_HOST') do
        fail(ArgumentError, 'Set TWITTER_HOST in the .env file')
      end
    end

    def jwt_token
      @jwt_token ||= Twitter::JWT.token
    end

    def url
      "#{host}/#{path}#{params}"
    end

    def params
      "?q=#{search_term}"
    end

    def path
      PATH
    end

    def request
      @request ||= HTTParty.get(url, headers: headers)
    end
  end
end
