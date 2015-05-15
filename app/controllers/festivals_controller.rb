class FestivalsController < ApplicationController

  before_action :consumer_user?

    def myfestivals
      @festivals = @current_user.event_occurrences.order(date: 'ASC').reduce([]) do |arr,occur|
        arr << occur.event.host unless arr.include? occur.event.host
        arr
      end
    end


    def index
      #Find all festivals (users that are both type host and verified)
      festivals = User.where(user_type:'host',status:true).order(name: 'ASC')
        # Loop through festivals and for each grab the events that they are hosting and grab tags associated with those events.
        @festival_details = festivals.map do |f|
         tags = f.hosted_events.map do |event|
                   event.tags
               end
        # Create an array of tags in strings and put dashes in between tags with multiple words. Also filter out multiple occurrences of tags.
         tags = tags.flatten.reduce([]) do |arr,tag|
            arr << tag.name.gsub(" ", "-") unless arr.include? tag.name.gsub(" ", "-")
            arr
          end
         # Create a hash of pertinent data.
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
          # Loop through each occurrence of the event
          event.event_occurrences.each do |occur|
            date_key = occur.date.to_date

            # Populate the date key if it is empty
            # Find if the event info already exists in the hash
            if @event_dates.has_key? date_key
              i = @event_dates[date_key].index { |e| e[:id] == occur.event_id }
            else
              @event_dates[date_key] = []
              i = nil
            end

            added = occur.users.include? User.find(@current_user.id)

            # If the info is not there, add it to the date key
            if i.nil?
              @event_dates[date_key] << {
                  name: event.name,
                  duration: event.duration,
                  image: event.image,
                  id:event.id,
                  tags: (event.tags.map { |tag| tag.name }).join(' '),
                  occurrences: [{time: occur.date.strftime("%I:%M %p"), location: occur.location, id: occur.id, added:added}]
                }
            # If the info is there, push the new occurrence into the data
            else
              @event_dates[date_key][i][:occurrences] << {time: occur.date.strftime("%I:%M %p"), location: occur.location, id: occur.id, added:added}
            end
          end
      end
      @event_dates
      # render json: @event_dates
    end

    def view
      @occurrences = @current_user.event_occurrences.joins(:event).where("events.host_id" => params[:id])
      # render json: {occurrences:@occurrences,events:@occurrences.map{|eo| eo.event}}
      render partial: 'festivals/myfestival_events'
    end

end