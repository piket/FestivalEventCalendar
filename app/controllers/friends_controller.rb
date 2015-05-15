class FriendsController < ApplicationController

    before_action :consumer_user?

    def index
    end

    def invite
        friend = User.where("lower(name) = ?", params[:name].downcase).first

        if friend.nil?
            friend = User.find_by_email params[:name]

            # if friend.nil?
            #     # render partial: 'friends_dashboard'
            #     raise "User not found"
            #     return
            # end
        end

        if friend && friend.user_type == 'consumer' && @current_user.user_type == 'consumer'
            success = @current_user.invite friend
            render partial: 'friends_list'
        else
            success = false
            raise "User not found"
        end
    end

    def accept
        success = @current_user.approve User.find params[:id]
        render partial: 'friends_list'
    end

    def decline
        success = @current_user.block User.find params[:id]
        render partial: 'friends_list'
    end

    def destroy
        friend = User.find params[:id]
        friend.remove_friendship @current_user
        success = @current_user.remove_friendship friend
        render partial: 'friends_list'
    end

    def list
        render partial: 'layouts/modal_friend_list', locals: {friends:@current_user.friends}
    end

end