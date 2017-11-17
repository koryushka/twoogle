require 'twitter/searcher'

class TweetsSearchService
  attr_reader :search_term, :order_by

  def initialize(search_term:, order_by: :created_at)
    self.search_term = search_term
    self.order_by = order_by.to_sym
  end

  def call
    {
      tweets: reordered_tweets,
      error: client.error
    }
  end

  private

  attr_writer :search_term, :order_by

  def reordered_tweets
    sliced_tweets.sort { |first, second| second[order_by] <=> first[order_by] }
  end

  def parsed_tweets
    tweets = client.search
    tweets = [] unless client.successful?
    tweets
  end

  def sliced_tweets
    slice_fields = %w[user created_at retweet_count favorite_count text]
    parsed_tweets.map do |tweet|
      tweet.slice(*slice_fields).symbolize_keys
    end
  end

  def client
    @client ||= Twitter::Searcher.new(search_term: search_term)
  end
end
