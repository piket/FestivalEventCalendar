class CommentsController < ApplicationController

#inbox
    def index
    end

#create for comments & messages
#no new route - comments created on event show page

    def create
      @event = Event.find params[:event_id]

      if params.key? :comment_id
        @current_user.comments << Comment.find(params[:comment_id]).comments.create(comment_params)
      else
        @current_user.comments << @event.comments.create(comment_params)
      end

      render :partial => 'layouts/comment_display', :collection => @event.comments

    end

#individual messages
    def show
    end

#delete messages
    def destroy
    end


    private

    def comment_params
      params.require(:comment).permit(:body)
    end



end