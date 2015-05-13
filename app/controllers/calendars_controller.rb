class CalendarsController < ApplicationController

before_action :is_authenticated?

  def index
    if @current_user && @current_user.id == params[:user_id].to_i
        @first_date = User.find(params[:user_id]).event_occurrences.where("event_occurrences.date >= ?", Date.today).order(date: 'ASC')
        @first_date = @first_date.empty? ? Date.today : @first_date.first.date.to_date
    else
        flash[:danger] = "You do not have permission to view this page."
        redirect_to root_path
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


      entries = User.find(params[:user_id]).event_occurrences.joins(:event).where('events.host_id' => params[:id])

    events = []
    entries.each do |entry|
      events << {:id => entry.event_id, :title => entry.event.name, :start => entry.date, :end => (entry.date + entry.event.duration.minutes), url:addevent_path(entry), className:'friend-event'}
    end
    render :json => events
  end


  def show
      if @current_user.id == params[:user_id].to_i || @current_user.friends.include?(User.find(params[:user_id]))
          @first_date = User.find(params[:user_id]).event_occurrences.joins(:event).where('events.host_id = ? AND event_occurrences.date >= ?', params[:id], Date.today).order(date: 'ASC')
          @first_date = @first_date.empty? ? Date.today : @first_date.first.date.to_date
          @festival = User.find params[:id]
      else
          flash[:danger] = "You do not have permission to view this page."
          redirect_to root_path
      end
  end

  def compare
      if params[:user_id] == params[:compare_id]
          flash[:danger] = "You cannot compare your calendar to itself."
          redirect_to root_path
      elsif @current_user.id == params[:user_id].to_i || @current_user.friends.include?(User.find(params[:user_id]))
          @first_date = User.find(params[:user_id]).event_occurrences.joins(:event).where('events.host_id = ? AND event_occurrences.date >= ?', params[:id], Date.today).order(date: 'ASC')
          @first_date = @first_date.empty? ? Date.today : @first_date.first.date.to_date
          @festival = User.find params[:id]
      else
          flash[:danger] = "You do not have permission to view this page."
          redirect_to root_path
      end
  end

  def compare_events
    entries = User.find(params[:user_id]).event_occurrences.joins(:event).where('events.host_id' => params[:id])

    events = []
    entries.each do |entry|
      events << {:id => entry.event_id, :title => entry.event.name, :start => entry.date, :end => (entry.date + entry.event.duration.minutes), backgroundColor: 'red', url:deleteevent_path(entry), className:'my-event'}
    end
    render :json => events
  end

end
