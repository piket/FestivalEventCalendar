class UsersController < ApplicationController

    def show
    end

    def edit
    end

    def update
        user_info = user_params_extended
        user = User.find session[:user_id]
        for field in user_info do
            user[field] = user_info[field]
        end
        user.save
        redirect_to user
    end

    private

    def user_params_extended
        params.require(:user).permit(:email, :name, :gender, :location, :age, :image)
    end

end