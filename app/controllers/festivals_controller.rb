class FestivalsController < ApplicationController

    def index
      festivals = User.where(user_type:'host',status:true)
        # render :json => festivals
        @festival_details = festivals.map do |f|
         tags = f.hosted_events.map do |event|
                   event.tags
               end

         tags = tags.flatten.reduce([]) {|arr,tag|arr << tag.name.gsub(" ", "-") unless arr.include? tag.name}

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