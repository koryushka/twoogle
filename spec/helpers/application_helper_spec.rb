require 'rails_helper'

RSpec.describe(ApplicationHelper) do
  describe('#options_for_select') do
    it 'returns correct options for select by default' do
      expected_options = '<option value="created_at">Created At</option>'\
        '<option value="favorite_count">Likes</option><option '\
        'value="retweet_count">Retweeted</option>'

      expect(helper.options_for_select).to eq(expected_options)
    end

    it 'returns correct options for select with param' do
      expected_options = '<option value="created_at">Created At</option>'\
        '<option value="favorite_count">Likes</option><option '\
        'value="retweet_count" selected="selected">Retweeted</option>'

      expect(helper.options_for_select(selected: 'Retweeted'))
        .to eq(expected_options)
    end
  end

  describe('#human_time') do
    it 'humanize time' do
      time = 'Tue Nov 14 08:30:23 +0000 2017'
      humanized_time = helper.human_time(time)

      expect(humanized_time).to eq('14-11-2017 08:30')
    end
  end
end
