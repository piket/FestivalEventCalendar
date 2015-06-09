class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :current_user
  before_action :unread_count

  def is_authenticated?
    unless @current_user
      flash[:warning] ="You must be logged in to access this page."
      redirect_to root_path
      return
      false
    end
    true
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])

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

  def unread_count
    if @current_user
      msgs = Comment.where(commentable_id: @current_user.id, commentable_type: 'User')
      @unread_count = 0
      msgs.each { |m| @unread_count += 1 if any_unread(m) }
      @unread_count
    end
  end

  def host_user?
    if is_authenticated?
      unless @current_user.user_type == 'host' && @current_user.status
        flash[:warning] = "You do not have access to this page."
        redirect_to root_path
      end
    end
  end

  def consumer_user?
    if is_authenticated?
      unless @current_user.user_type == 'consumer'
        flash[:warning] = "You do not have access to this page."
        redirect_to root_path
      end
    end
  end

end
