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
            id: f.id,
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
      # find the festival
      @festival = User.find params[:id]
      # Generate empty hash of dates
      @event_dates = {}
      # Loop through each event under the festival
      @festival.hosted_events.each do |event|
        # Generate a hash with the event info
          info = {
            name: event.name,
            image: event.image,
            id:event.id,
            tags: (event.tags.map { |tag| tag.name }).join(' '),
            occurrences: []
          }

          # Loop through each occurrence of the event
          event.event_occurrences.each do |occur|
            # Populate the date key if it is empty
            @event_dates[occur.date.to_date] = [info] unless @event_dates.has_key? occur.date.to_date
            # Find if the event info already exists in the hash
            i = @event_dates[occur.date.to_date].index { |e| e[:id] == occur.event_id }
            # If the info is not there, add it to the date key
            if i.nil?
              info[:occurrences] << {time: occur.date.strftime("%I:%M %p"), location: occur.location}
              @event_dates[occur.date.to_date] << info
            # If the info is there, push the new occurrence into the data
            else
              @event_dates[occur.date.to_date][i][:occurrences] << {time: occur.date.strftime("%I:%M %p"), location: occur.location}
            end
          end
      end

      # render json: @event_dates
    end



end