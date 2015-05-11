class FriendsController < ApplicationController

    before_action :is_authenticated?

    def index
    end

    def invite
        friend = User.where("lower(name) = ?", params[:name].downcase).first

        if friend.nil?
            friend = User.find_by_email params[:name]

            if friend.nil?
                render partial: 'friends_dashboard'
                return
            end
        end

        if friend
            success = @current_user.invite friend
        else
            success = false
        end
        render partial: 'friends_dashboard'
    end

    def accept
        success = @current_user.approve User.find params[:id]
        render partial: 'friends_dashboard'
    end

    def decline
        success = @current_user.block User.find params[:id]
        render partial: 'friends_dashboard'
    end

    def destroy
        friend = User.find params[:id]
        friend.remove_friendship @current_user
        success = @current_user.remove_friendship friend
        render partial: 'friends_dashboard'
    end

end