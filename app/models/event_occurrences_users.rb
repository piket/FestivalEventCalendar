class EventOccurrencesUsers < ActiveRecord::Base
  belongs_to :event_occurrence
  belongs_to :user
  # Forces unique rows: a user cannot have the same event occurrance more than once
  validates :user_id, presence: true
  validates :event_occurrence_id, presence: true

  validates_uniqueness_of :user_id, scope: :event_occurrence_id
end
