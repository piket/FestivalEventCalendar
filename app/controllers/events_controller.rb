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

   def import
     rows = Event.import(params[:file])
     # render json: rows
     # return
     rows.each do |row|
         event = Event.create({name:row['name'], description: row['description'], image: row['image'], video: row['video'], link: row['link'], purchase: row['purchase'], price: row['price']})

         if row['dates'].length == row['times'].length && row['dates'].length == row['locations'].length
            for x in 0...row['dates'].length
               row['times'][x][0] = row['times'][x][0].to_i
               row['times'][x][0] += 12 if row['times'][x][2].casecmp('pm') == 0 && row['times'][x][0] != 12
               datetime = DateTime.new(row['dates'][x][2].to_i,row['dates'][x][0].to_i,row['dates'][x][1].to_i,row['times'][x][0],row['times'][x][1].to_i)
               event.event_occurrences.create({date: datetime, location: row['locations'][x]})
            end
         elsif row['dates'].length >= row['times'].length && row['dates'].length >= row['locations'].length
            for x in 0...row['dates'].length
               row['times'][0][0] = row['times'][0][0].to_i
               row['times'][0][0] += 12 if row['times'][0][2].casecmp('pm') == 0 && row['times'][0][0] != 12
               datetime = DateTime.new(row['dates'][x][2].to_i,row['dates'][x][0].to_i,row['dates'][x][1].to_i,row['times'][0][0],row['times'][0][1].to_i)
               event.event_occurrences.create({date: datetime, location: row['locations'][0]})
               # render json: {row:row,occurrences:event.event_occurrences}
               # return
            end
         elsif row['times'].length >= row['dates'].length && row['times'].length >= row['locations'].length
            for x in 0...row['times'].length
               row['times'][x][0] = row['times'][x][0].to_i
               row['times'][x][0] += 12 if row['times'][x][2].casecmp('pm') == 0 && row['times'][x][0] != 12
               datetime = DateTime.new(row['dates'][0][2].to_i,row['dates'][0][0].to_i,row['dates'][0][1].to_i,row['times'][x][0],row['times'][x][1].to_i)
               event.event_occurrences.create({date: datetime, location: row['locations'][0]})
            end
         elsif row['locations'].length >= row['times'].length && row['locations'].length >= row['dates'].length
            for x in 0...row['locations'].length
               row['times'][0][0] = row['times'][0][0].to_i
               row['times'][0][0] += 12 if row['times'][0][2].casecmp('pm') == 0 && row['times'][0][0] != 12
               datetime = DateTime.new(row['dates'][0][2].to_i,row['dates'][0][0].to_i,row['dates'][0][1].to_i,row['times'][0][0],row['times'][0][1].to_i)
               event.event_occurrences.create({date: datetime, location: row['locations'][x]})
            end
         end

         row['tags'].each do |tag|
            event.tags << Tag.find_or_create_by(name: tag)
         end

         @current_user.hosted_events << event
      end
      # render json: @current_user.hosted_events
     flash[:success] = "File imported and new events added"
     redirect_to root_path
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