class EventsController < ApplicationController

   def new
      @event = Event.new
   end

   def create
      @event = Event.create(event_params)
      @event.price = params[:event][:price].to_f
      @event.event_occurrences.create(occurrence_params)
      @current_user.hosted_events << @event

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
      params.require(:event).permit([:location, :date])
   end



end