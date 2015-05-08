class EventsController < ApplicationController

   def new
      @event = Event.new
   end

   def create
      @event = Event.create(event_params)
      @event.price = params[:event][:price].to_f
      # Create each occurrence
      occurrence_params.each do |occurrence|
         @event.event_occurrences.create({location: occurrence[:location], date: occurrence[:date]}) unless occurrence[:deleted]
      end
      @current_user.hosted_events << @event
      redirect_to user_path(@current_user)
   end

   def edit
      @event = Event.find params[:id]
   end

   def update
      @event = Event.update params[:id], event_params
      @event.price = params[:event][:price].to_f
      # Create each occurrence

      occurrences = occurrence_params
      # render json: {params:params,occurrences:occurrences}
      current_occurrences = @event.event_occurrences.sort {|a,b| a.id - b.id }
      # render json: occurrences
      # return
      for i in 0...occurrences.length
         if i < @event.event_occurrences.length
            if occurrences[i][:deleted]
               @event.event_occurrences.delete(current_occurrences[i])
               current_occurrences[i].destroy
            else
               current_occurrences[i].update({location: occurrences[i][:location], date: occurrences[i][:date]})
            end
         elsif !occurrences[i][:deleted]
            @event.event_occurrences.create({location: occurrences[i][:location], date: occurrences[i][:date]})
         end
      end
      redirect_to user_path(@current_user)
   end

   def destroy
   end


   private

   def event_params
      params.require(:event).permit([:name, :description, :image, :video, :link, :purchase])

   end

   def occurrence_params
      occurrence = Array.new
      if params[:multiple] == "false"
         # Split date string into array with index 0=month, 1=day, 2=year. Then map the array to convert the strings into integers
         event_date = params[:event][:date]['0'].split('.').map { |str| str.to_i }

         # Split time string into arry with index 0=hour, 1=minute, 2=am/pm. Then map the array to turn the strings into integers except for am/pm
         event_time = params[:event][:time]['0'].split(/[: ]/).map { |str| (str.casecmp('am') == 0 || str.casecmp('pm') == 0) ? str : str.to_i }

         # Adjust the hour to be the correct 24hr time
         event_time[0] += 12 if event_time[2].casecmp('pm') == 0 && event_time[0] != 12

         params_hash = {deleted: false}
      # Generate DateTime from date and time arrays in format: year, month, day, hour, minute
         params_hash[:date] = DateTime.new(event_date[2],event_date[0],event_date[1],event_time[0],event_time[1])
         params_hash[:location] = params[:event][:location]['0']
         occurrence << params_hash
      else
         for x in (0...params[:event][:date].length)
            if params[:event].has_key?(:deleted) && params[:event][:deleted].has_key?(x.to_s)
               occurrence << {deleted: true}
            else
               event_date = params[:event][:date][x.to_s].split('.').map { |str| str.to_i }
               event_time = params[:event][:time][x.to_s].split(/[: ]/).map { |str| (str.casecmp('am') == 0 || str.casecmp('pm') == 0) ? str : str.to_i }

               event_time[0] += 12 if event_time[2].casecmp('pm') == 0 && event_time[0] != 12

               params_hash = {deleted: false}
               params_hash[:date] = DateTime.new(event_date[2],event_date[0],event_date[1],event_time[0],event_time[1])
               params_hash[:location] = params[:event][:location][x.to_s]

               occurrence << params_hash
            end
         end
      end
      occurrence
   end



end