require 'rails_helper'

RSpec.feature('Tweets search') do
  scenario('displays appropriate tweets') do
    visit root_path

    VCR.use_cassette('twitter/jwt') do
      VCR.use_cassette('twitter/searcher') do
        fill_in 'search_term', with: 'ruby on rails'
        click_on 'search'
        expected_results = %w[ruby rails ror rubyonrails]

        all('.content').each do |el|
          match = expected_results.any? do |word|
            el.text.downcase.include?(word)
          end

          expect(match).to be_truthy
        end
      end
    end
  end

  context('shows search conditions') do
    scenario('without order_by selected') do
      visit root_path

      VCR.use_cassette('twitter/jwt') do
        VCR.use_cassette('twitter/searcher') do
          fill_in 'search_term', with: 'ruby on rails'
          click_on 'search'

          expect(page).to have_content(
            'Search term: "ruby on rails", Orderded by: Created At'
          )
        end
      end
    end

    scenario('with order_by likes') do
      visit root_path

      VCR.use_cassette('twitter/jwt') do
        VCR.use_cassette('twitter/searcher') do
          fill_in 'search_term', with: 'ruby on rails'
          select('Likes', from: 'order_by')
          click_on 'search'

          expect(page).to have_content(
            'Search term: "ruby on rails", Orderded by: Likes'
          )
        end
      end
    end

    context('when authentication fails') do
      scenario('it displays error message') do
        visit root_path

        VCR.use_cassette('twitter/jwt') do
          VCR.use_cassette('twitter/searcher-invalid-token') do
            fill_in 'search_term', with: 'ruby on rails'
            click_on 'search'

            expect(page).to have_content(
              'We are sorry, but something went wrong.'
            )
          end
        end
      end
    end
  end
end
