class Event < ActiveRecord::Base
  # Organizer_id represents the organization that created the events and thus the festival the event falls under
  belongs_to :host, class_name: 'User', foreign_key: :host_id
  # Allows commenting
  has_many :comments, as: :commentable
  has_many :event_occurrences
  # Allows having many tags
  has_and_belongs_to_many :tags
  # Allows many users to select the event for their calendars
  has_and_belongs_to_many :users

end
