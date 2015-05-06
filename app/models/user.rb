class User < ActiveRecord::Base
    # Creates a bcrypted password
    has_secure_password
    # An organizer has many events, they are called organized_events
    has_many :hosted_events, class_name: 'Event', foreign_key: :host_id
    # Allows a user to select many events for their calendar
    has_and_belongs_to_many :event_occurrences

end
