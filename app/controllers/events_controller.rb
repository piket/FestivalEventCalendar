class EventsController < ApplicationController

   def new
      @event = Event.new
   end

   def create
      @event = Event.create(event_params)
      @event.price = params[:event][:price].to_f
      @event.event_occurrences.create(occurrence_params)
      @current_user.hosted_events << @event
      redirect_to user_path(@current_user)
   end

   def edit
   end

   def update
   end

   def destroy
   end


   private

   def event_params
      params.require(:event).permit([:name, :description, :image, :video, :link, :purchase])

   end

   def occurrence_params
      occurrence = params.require(:event).permit([:location])
      # Split date string into array with index 0=month, 1=day, 2=year. Then map the array to convert the strings into integers
      event_date = params[:event][:date].split('.').map { |str| str.to_i }
      # Split time string into arry with index 0=hour, 1=minute, 2=am/pm. Then map the array to turn the strings into integers except for am/pm
      event_time = params[:event][:time].split(/[: ]/).map { |str| (str.casecmp('am') == 0 || str.casecmp('pm') == 0) ? str : str.to_i }
      # Adjust the hour to be the correct 24hr time
      event_time[0] += 12 if event_time[2].casecmp('pm') && event_time[0] != 12
      # Generate DateTime from date and time arrays in format: year, month, day, hour, minute
      occurrence[:date] = DateTime.new(event_date[2],event_date[0],event_date[1],event_time[0],event_time[1])
      occurrence
   end



end