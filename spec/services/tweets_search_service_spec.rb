require 'rails_helper'

RSpec.describe(TweetsSearchService) do
  describe('.call') do
    it 'returns tweets ordered by `created_at` by default' do
      subject = described_class.new(search_term: 'ruby on rails')
      VCR.use_cassette('twitter/jwt') do
        VCR.use_cassette('twitter/searcher') do
          time_array = subject.call[:tweets].pluck(:created_at)
          sorted_times = time_array.sort.reverse

          expect(time_array).to eq(sorted_times)
        end
      end
    end

    context 'reorders tweets accodingly' do
      it 'by popularity' do
        subject = described_class.new(search_term: 'ruby on rails',
                                      order_by: :favorite_count)
        VCR.use_cassette('twitter/jwt') do
          VCR.use_cassette('twitter/searcher') do
            likes_array = subject.call[:tweets].pluck(:favorite_count)
            sorted_likes = likes_array.sort.reverse

            expect(likes_array).to eq(sorted_likes)
          end
        end
      end

      it 'by retweet count' do
        subject = described_class.new(search_term: 'ruby on rails',
                                      order_by: :retweet_count)
        VCR.use_cassette('twitter/jwt') do
          VCR.use_cassette('twitter/searcher') do
            retweets_array = subject.call[:tweets].pluck(:retweet_count)
            sorted_retweets= retweets_array.sort.reverse

            expect(retweets_array).to eq(sorted_retweets)
          end
        end
      end
    end

    context('when it fails') do
      it 'returns error' do

      end
    end
  end
end
