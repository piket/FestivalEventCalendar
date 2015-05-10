class User < ActiveRecord::Base
    include Amistad::FriendModel

    # Creates a bcrypted password
    has_secure_password
    # An organizer has many events, they are called organized_events
    has_many :hosted_events, class_name: 'Event', foreign_key: :host_id
    # Allows a user to select many events for their calendar
    has_and_belongs_to_many :event_occurrences

    def self.authenticate email, password
      user= User.find_by_email(email)

      if user && user.password_digest == "fb_authenticated"
        "fb_authenticated"
      else
        user
      end

    end



end
