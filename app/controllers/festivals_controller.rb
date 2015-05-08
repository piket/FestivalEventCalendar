class FestivalsController < ApplicationController

    def index
      #Find all festivals (users that are both type host and verified)
      festivals = User.where(user_type:'host',status:true)
        # Loop through festivals and for each grab the events that they are hosting and grab tags associated with those events.
        @festival_details = festivals.map do |f|
         tags = f.hosted_events.map do |event|
                   event.tags
               end
        # Create an array of tags in strings and put dashes in between tags with multiple words. Also filter out multiple occurrences of tags.
         tags = tags.flatten.reduce([]) {|arr,tag|arr << tag.name.gsub(" ", "-") unless arr.include? tag.name}
         # Create a hash of pertinent data.
          temp_hash = {
            name: f.name,
            location: f.location,
            image: f.image,
            about: f.about,
            tags: tags.join(" ")
          }

        end
        # render :json => @festival_details
    end

    def show
    end



end