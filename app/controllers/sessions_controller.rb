class SessionsController < ApplicationController

#user login
  def new
  end

#create new user session
  def create
    # render json: params
    # return
    user_info = login_params
    @user = User.authenticate user_info[:email], user_info[:password]

    if @user == "fb_authenticated"
      redirect_to "/auth/facebook"
    elsif @user
      session[:user_id]= @user.id
      flash[:success] ="You have been logged in!"
      # redirect_to root_path
      render json: {result:true}
    else
      # flash[:danger] = "Invalid credentials. Please try to login again!"
      # redirect_to login_path
      render json: {result:false,msg:"Invalid credentials. Please try to login again!"}
    end

  end

#user logout
  def destroy
    session[:user_id] = nil
    flash[:primary] = "You have been successfully logged out!"
    redirect_to root_path
  end


  private

  def login_params
    params.require(:user).permit(:email, :password)
  end




end