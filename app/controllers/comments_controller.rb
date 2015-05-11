class CommentsController < ApplicationController

  before_action :is_authenticated?, except: [:index]

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
      comment = Comment.find params[:id]

      if comment.user_id == @current_user.id
        comment.destroy
      end
      @messages = Comment.where(commentable_id: @current_user.id, commentable_type: 'User')
      render :partial => 'layouts/messages'
    end


    private

    def comment_params
      params.require(:comment).permit(:body)
    end



end