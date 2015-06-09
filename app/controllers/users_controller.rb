class UsersController < ApplicationController

  before_action :is_authenticated?, except: [:new, :create, :show]
  before_action :consumer_user?, only: [:show]



    def addevent
      result = EventOccurrence.find(params[:id])

      if @current_user.user_type != 'consumer' || result.users.include?(@current_user)
        render :json => {result:false}
      else
          if result.users.include? @current_user
            render json: {result:false}
          else
            @current_user.event_occurrences << result
            render :json => {result:params[:id]}
          end
      end
    end


    def deleteevent
        result = EventOccurrence.find(params[:id])

      if @current_user.user_type == 'consumer' && result.users.include?(@current_user)
        @current_user.event_occurrences.delete(result)
        render :json => {result:params[:id]}
      else
        render :json => {result:false}

      end
    end

    def index
    end

    def show
      @user = User.find params[:id]
      @message = Comment.new

      unless @user.user_type == 'host' || @current_user.friends.include?(@user)
        flash[:primary] = "You must be friends to view this profile."
        redirect_to users_path
      end
    end

    def edit
      render partial: 'edit_form'
    end

    def update
      # render json: params
      # return
        user_info = user_params_extended
        user = User.find session[:user_id]
        if params[:user][:image].present?
          preloaded = Cloudinary::PreloadedFile.new(params[:user][:image])
          raise "Invalid upload signature" if !preloaded.valid?
          user.image = preloaded.identifier
        end
        user_info.each_pair do |field, value|
            user[field] = value
        end
        user.save
        # redirect_to users_path
        redirect_to friends_path
        # @current_user = User.find(@current_user.id)
        # render partial: 'profile'
    end

    # routes
    def new
      @user = User.new
      render partial: 'signup_form'
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
        user.image = params[:user][:user_type] == "1" ? "festival_default" : "user_default"
        if user.save
          flash[:success] = "Your account has successfully been created!"
          session[:user_id] = user.id
          #CHANGE TO REDIRECT AND AUTO LOGIN
          redirect_to root_path

        else
          flash[:danger] = "Error. Invalid information inputed."
          redirect_to root_path
        end

      else
        flash[:primary] = "We already have an account under that email address. Please try again or login!"
        redirect_to root_path
      end
    end


    private

    def user_params
      params.require(:user).permit([:name, :email, :password])
    end

    def user_params_extended
        params.require(:user).permit(:email, :name, :gender, :location, :age, :about)
    end

end