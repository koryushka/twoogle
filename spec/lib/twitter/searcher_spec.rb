require 'rails_helper'
require 'twitter/searcher'

RSpec.describe(Twitter::Searcher) do
  describe('.search') do
    it 'returns array of tweets' do
      subject = described_class.new(search_term: 'ruby on rails')
      VCR.use_cassette('twitter/jwt') do
        VCR.use_cassette('twitter/searcher') do
          expect(subject.search).to be_a Array
        end
      end
    end

    context('when it fails') do
      it 'returns false' do
        subject = described_class.new(search_term: 'ruby on rails')
        VCR.use_cassette('twitter/jwt') do
          VCR.use_cassette('twitter/searcher-invalid-token') do

            expect(subject.search).to eql(false)
          end
        end
      end
    end

    context('when authentication fails')do
      it 'logs an error' do
        VCR.use_cassette('twitter/jwt') do
          VCR.use_cassette('twitter/searcher-invalid-token') do
              expect(Rails.logger).to receive(:error).with(
                '[Twitter]: search error - Invalid or expired token.'
              )
              subject = described_class.new(search_term: 'ruby on rails')
              subject.search
          end
        end
      end
    end
  end
end
