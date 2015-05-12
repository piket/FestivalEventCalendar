class CalendarsController < ApplicationController

before_action :is_authenticated?

  def index
    if @current_user.user_type == 'host'
        redirect_to(:back)
      end

  end

  def all_events
    entries = @current_user.event_occurrences
    events = []
    entries.each do |entry|
      events << {:id => entry.event_id, :title => entry.event.name, :start => entry.date, :end => (entry.date + entry.event.duration.minutes)}
    end
    render :json => events
  end


  def get_events


      entries = @current_user.event_occurrences.joins(:event).where('events.host_id' => params[:id])

    events = []
    entries.each do |entry|
      events << {:id => entry.event_id, :title => entry.event.name, :start => entry.date, :end => (entry.date + entry.event.duration.minutes)}
    end
    render :json => events
  end


  def show
   if @current_user.user_type == 'host'
        redirect_to(:back)
      end

      @festival = User.find params[:id]

  end


end
