module ApplicationHelper
  def options_for_select(selected: nil)
    select_mapping.each_with_object('') do |(key, value), str|
      string = if value == selected
         "<option selected value='#{key}'>#{value}</option>"
       else
         "<option value='#{key}'>#{value}</option>"
       end
      str << string
    end
  end

  def human_time(time)
    time.to_datetime.strftime('%d-%m-%Y %H:%M')
  end

  def select_mapping
    {
      favorite_count: 'Likes',
      retweet_count: 'Retweeted',
      created_at: 'Created At'
    }
  end
end
