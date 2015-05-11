module ApplicationHelper

  def format_created_time item
    if item.created_at > Time.now.beginning_of_day
      "#{time_ago_in_words(item.created_at)} ago"

    else
      item.created_at.strftime("%e %b %Y %H:%M")
    end
  end

    def any_unread message
        puts "Checking unread: #{message.unread}"
        if message.unread && @current_user.id == message.original_id
            true
        else
            message.comments.each do |m|
                if any_unread m
                    true
                    return
                end
            end
            false
        end
    end

end
