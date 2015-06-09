class EventsTags < ActiveRecord::Base
  belongs_to :event
  belongs_to :tag
  # Forces unique rows: an event cannot have a tag more than once
  validates :event_id, presence: true
  validates :tag_id, presence: true

  validates_uniqueness_of :event_id, scope: :tag_id

end
