class EventsUsers < ActiveRecord::Base
  belongs_to :event
  belongs_to :user

  # Forces unique rows only: a user may not pick the same event twice
  validates :user_id, presence: true
  validates :event_id, presence: true

  validates_uniqueness_of :event_id, scope: :user_id

end
