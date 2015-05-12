class AuthController < ApplicationController

    def failure
      flash[:danger] = "FACEBOOK LOGIN ERROR. Please try again!"
      redirect_to login_path
    end

    def callback
      provider_user = request.env['omniauth.auth']

      user = User.find_or_initialize_by(provider_id:provider_user['uid'], provider: params[:provider])

      if user.new_record?
        user.password_digest = "fb_authenticated"
        user.provider_hash = provider_user['credentials']['token']
        user.name = provider_user['info']['name']
        user.email = provider_user['info']['email']
        user.gender = provider_user['extra']['raw_info']['gender']

        if !provider_user['info']['image'].empty?
            user.image = Cloudinary::Uploader.upload(provider_user['info']['image'])['public_id']
        end

        user.status = true
        user.user_type = "consumer"
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
        flash[:success] = "You have been successfully logged in!"
        session[:user_id] = user.id
        redirect_to root_path
        # render :json => provider_user
      end
    end
end