module ApplicationHelper

  def format_created_time item
    if item.created_at > Time.now.beginning_of_day
      "#{time_ago_in_words(item.created_at)} ago"

    else
      item.created_at.strftime("%e %b %Y %H:%M")
    end
  end

end
