class FriendsController < ApplicationController

    def index
    end

    def invite
        friend = User.find_by_name params[:friend][:name]

        if friend.nil?
            friend = User.find_by_email params[:friend][:name]

            if friend.nil?
                render json: {found:false, success:false}
                return
            end
        end

        if friend
            success = !(@current_user.invite friend)
        else
            success = false
        end
        render json: {found:true,success:success}
    end

    def accept
        @current_user.approve User.find params[:friend][:id]
    end

    def decline
        @current_user.block User.find params[:id]
    end

    def destroy
        @current_user.remove_friendship User.find params[:id]
    end

end