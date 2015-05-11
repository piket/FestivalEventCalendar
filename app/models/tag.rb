class Tag < ActiveRecord::Base

    has_and_belongs_to_many :events
    # Forces each tag to be unique
    validates :name, uniqueness: {case_sensitive: false}, presence: true

end
