class EventsController < ApplicationController

   before_action :host_user?, except: [:show]
   before_action :is_authenticated?, only: [:show]

   def index

      @events = Event.where(:host_id => @current_user.id).order(name: 'ASC')
      # render :json => @events
   end

   def show
      @event = Event.find_by_id(params[:id])
      @comment = Comment.new
      @comment_ref = false

   end

   def new
      @event = Event.new
      @tags = ""
   end

   def create
      @event = Event.create(event_params)
      @event.price = params[:event][:price].to_f
      @event.duration = proccess_duration params[:event][:duration]

      if params[:event][:image].present?
         preloaded = Cloudinary::PreloadedFile.new(params[:event][:image])
         raise "Invalid upload signature" if !preloaded.valid?
         @event.image = preloaded.identifier
      else
         @event.image = "event_default"
      end

      if params[:event][:video].include? 'youtube.com'
         vid = params[:event][:video]
         @event.video = vid[vid.index('?v=')+3...vid.length]
      end

      params[:event][:tags].split(',').each do |tag|
         tag.strip!
         tag.downcase!
         @event.tags << Tag.find_or_create_by(name: tag) unless tag.blank?
      end
      # Create each occurrence
      occurrence_params.each do |occurrence|
         @event.event_occurrences.create({location: occurrence[:location], date: occurrence[:date]}) unless occurrence[:deleted]
      end
      @event.save
      @current_user.hosted_events << @event
      redirect_to users_path
   end

   def edit
      @event = Event.find params[:id]
      @tags = @event.tags.reduce("") { |str,tag| str == "" ? str + tag.name : str + "," + tag.name }
   end

   def update
      @event = Event.update params[:id], event_params
      @event.price = params[:event][:price].to_f
      @event.duration = proccess_duration params[:event][:duration]
      if params[:event][:image].present?
         Cloudinary::Uploader.destroy(@event.image[@event.image.index('/')+1...@event.image.length], :invalidate => true) unless @event.image.nil?
         preloaded = Cloudinary::PreloadedFile.new(params[:event][:image])
         raise "Invalid upload signature" if !preloaded.valid?
         @event.image = preloaded.identifier
      end

      if params[:event][:video].include? 'youtube.com'
         vid = params[:event][:video]
         @event.video = vid[vid.index('?v=')+3...vid.length]
      end

      @event.tags.clear
      params[:event][:tags].split(',').each do |tag|
         tag.strip!
         tag.downcase!
         @event.tags << Tag.find_or_create_by(name: tag) unless tag.blank?
      end
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
      @event.save
      redirect_to users_path
   end

   def destroy
      Event.find(params[:id]).destroy
   end

   def import
     rows = Event.import(params[:file])
     rows.each do |row|
     # render json: row
     # return
         event = Event.create({name:row['name'], description: row['description'], video: row['video'], link: row['link'], purchase: row['purchase'], price: row['price']})

         if row['dates'].length == row['times'].length && row['dates'].length == row['locations'].length
            for x in 0...row['dates'].length
               hour = row['times'][x][0] + (row['times'][x][2].casecmp('pm') == 0 && row['times'][x][0] < 12 ? 12:0)
               datetime = DateTime.new(row['dates'][x][2],row['dates'][x][0],row['dates'][x][1],hour,row['times'][x][1])
               event.event_occurrences.create({date: datetime, location: row['locations'][x]})
            end
         elsif row['dates'].length >= row['times'].length && row['dates'].length >= row['locations'].length
            for x in 0...row['dates'].length
               hour = row['times'][0][0] + (row['times'][0][2].casecmp('pm') == 0 && row['times'][0][0] < 12 ? 12:0)
               puts "Date Array: #{row['dates'][x]}\nTime Array: #{row['times'][0]}"
               datetime = DateTime.new(row['dates'][x][2],row['dates'][x][0],row['dates'][x][1],hour,row['times'][0][1])
               event.event_occurrences.create({date: datetime, location: row['locations'][0]})
               puts "X=#{x}, Length=#{row['dates'].length}, DateTime=#{datetime}"
               # render json: {title:row['name'],dates:row['dates'],times:row['times']}
               # return
            end
         elsif row['times'].length >= row['dates'].length && row['times'].length >= row['locations'].length
            for x in 0...row['times'].length
               hour = row['times'][x][0] + (row['times'][x][2].casecmp('pm') == 0 && row['times'][x][0] < 12 ? 12:0)
               datetime = DateTime.new(row['dates'][0][2],row['dates'][0][0],row['dates'][0][1],hour,row['times'][x][1])
               event.event_occurrences.create({date: datetime, location: row['locations'][0]})
            end
         elsif row['locations'].length >= row['times'].length && row['locations'].length >= row['dates'].length
            for x in 0...row['locations'].length
               hour = row['times'][0][0] + (row['times'][0][2].casecmp('pm') == 0 && row['times'][0][0] < 12 ? 12:0)
               datetime = DateTime.new(row['dates'][0][2],row['dates'][0][0],row['dates'][0][1],hour,row['times'][0][1])
               event.event_occurrences.create({date: datetime, location: row['locations'][x]})
            end
         end

         if !row['image'].nil? && !row['image'].empty?
            event.image = Cloudinary::Uploader.upload(row['image'])['public_id']
         else
            event.image = "event_default"
         end

         if !row['video'].nil? && row['video'].include?('youtube.com')
            vid = row['video']
            event.video = vid[vid.index('?v=')+3...vid.length]
         end

         event.duration = proccess_duration(row['duration'])

         row['tags'].each do |tag|
            tag.downcase!
            event.tags << Tag.find_or_create_by(name: tag)
         end

         event.save
         @current_user.hosted_events << event
      end
      # render json: @current_user.hosted_events
     flash[:success] = "File imported and new events added"
     redirect_to users_path
   end


   private

   def event_params
      params.require(:event).permit([:name, :description, :link, :purchase, :host_id, :location, :date])

   end

   def occurrence_params
      occurrence = Array.new
      if params[:multiple] == "false"
         # Split date string into array with index 0=month, 1=day, 2=year. Then map the array to convert the strings into integers
         event_date = params[:event][:date]['0'].split('.').map { |str| str.to_i }

         # Split time string into arry with index 0=hour, 1=minute, 2=am/pm. Then map the array to turn the strings into integers except for am/pm
         event_time = params[:event][:time]['0'].split(/[: ]/).map { |str| (str.casecmp('am') == 0 || str.casecmp('pm') == 0) ? str : str.to_i }

         # Adjust the hour to be the correct 24hr time
         event_time[0] += 12 if event_time[2].casecmp('pm') == 0 && event_time[0] < 12

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

               event_time[0] += 12 if event_time[2].casecmp('pm') == 0 && event_time[0] < 12

               params_hash = {deleted: false}
               params_hash[:date] = DateTime.new(event_date[2],event_date[0],event_date[1],event_time[0],event_time[1])
               params_hash[:location] = params[:event][:location][x.to_s]

               occurrence << params_hash
            end
         end
      end
      occurrence
   end

   def proccess_duration duration_str
      if duration_str.nil?
         return nil
      end

      duration_str.downcase!

      if duration_str.include? ':'
         duration_arr = duration_str.split(':')
         duration_arr[0].to_i * 60 + duration_arr[1].to_i
      elsif duration_str.include? 'h'
         duration_str.to_f * 60
      else
         duration_str.to_i
      end
   end

end