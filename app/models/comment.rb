class Comment < ActiveRecord::Base
  # User_id represents the user that made the comment
  belongs_to :user
  # Allows for multiple models to be commented on
  belongs_to :commentable, polymorphic: true
  # Allows for comments to be commented on
  has_many :comments, as: :commentable

  validates :body, presence: true
  # validates :user_id, presence: true

end
