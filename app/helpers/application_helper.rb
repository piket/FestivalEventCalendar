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
        unread = false
        if message.unread && @current_user.id != message.user_id && @current_user.id == message.original_id
            unread = true
        else
            for x in 0...message.comments.length
                if any_unread message.comments[x]
                    unread = true
                    break
                end
            end
        end
        unread
    end

end
