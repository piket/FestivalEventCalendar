class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :current_user
  before_action :unread_count

  def is_authenticated?
    unless @current_user
      flash[:warning] ="You must be logged in to access this page."
      redirect_to login_path
    end
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])

  end

  def unread_count
    if @current_user
      msgs = Comment.where(commentable_id: @current_user.id, commentable_type: 'User')
      @unread_count = msgs.count { |m| any_unread m }
      @unread_count
    end
  end

  def host_user?
    is_authenticated?
    unless @current_user.user_type == 'host' && @current_user.status
      flash[:warning] = "You do not have access to this page."
      redirect_to :back
    end
  end

end
