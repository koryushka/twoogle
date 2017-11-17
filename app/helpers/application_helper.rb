module ApplicationHelper
  def options_for_select(selected: nil)
    safe_join(
      select_mapping.each_with_object([]) do |(key, value), out|
        options = { value: key }
        options[:selected] = true if selected?(value, selected)
        out << content_tag(:option, value, options)
      end
    )
  end

  def selected?(value, selected)
    value == selected
  end

  def human_time(time)
    time.to_datetime.strftime('%d-%m-%Y %H:%M')
  end

  def select_mapping
    {
      created_at: 'Created At',
      favorite_count: 'Likes',
      retweet_count: 'Retweeted'
    }
  end
end
