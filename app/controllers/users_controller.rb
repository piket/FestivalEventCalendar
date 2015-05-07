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

    # routes
    def new
      @user = User.new
    end

    def create
      #Create new User
      user_info = user_params


      user = User.find_or_initialize_by(email:user_info[:email])

      if user.new_record?
        user.password = user_info[:password]
        user.name = user_info[:name]
        user.status = params[:user][:user_type] == "1" ? false:true
        user.user_type = params[:user][:user_type] == "1" ? "host" : "consumer"
        if user.save
          flash[:success] = "Your account has successfully been created!"
          session[:user_id] = user.id
          #CHANGE TO REDIRECT AND AUTO LOGIN
          redirect_to root_path

        else
          flash[:danger] = "Error. Invalid information inputed."
          redirect_to new_user_path
        end

      else
        flash[:primary] = "We already have an account under that email address. Please try again or login!"
        redirect_to new_user_path
      end
    end


    private

    def user_params
      params.require(:user).permit([:name, :email, :password])
    end

    def user_params_extended
        params.require(:user).permit(:email, :name, :gender, :location, :age, :image)
    end

end