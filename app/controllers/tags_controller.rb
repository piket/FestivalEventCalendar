class TagsController < ApplicationController

    before_action :host_user?, only: [:new, :create]
    before_action :is_authenticated?, only: [:index]

    def index
      @tags = Tag.all.order('name ASC')
    end

    def new
      @tag = Tag.new
    end

    def create
      @tag = Tag.create(tag_params)
      redirect_to tags_path
    end

    private

    def tag_params
      params.require(:tag).permit(:name)

    end



end