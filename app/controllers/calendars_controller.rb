class CalendarsController < ApplicationController

before_action :consumer_user?

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
      events << {:id => entry.event_id, :title => entry.event.name, :start => entry.date, :end => (entry.date + entry.event.duration.minutes), url:deleteevent_path(entry), backgroundColor: 'rgb(6,22,62)', textColor:'rgb(129,239,188)', className:'my-event'}
    end
    render :json => events
  end


  def get_events


      entries = User.find(params[:user_id]).event_occurrences.joins(:event).where('events.host_id' => params[:id])

    events = []
    entries.each do |entry|
      events << {:id => entry.event_id, :title => entry.event.name, :start => entry.date, :end => (entry.date + entry.event.duration.minutes), backgroundColor: 'rgb(6,22,62)', textColor:'rgb(129,239,188)', url:deleteevent_path(entry), className:'my-event'}
    end
    render :json => events
  end


  def show
      if @current_user.id == params[:user_id].to_i || @current_user.friends.include?(User.find(params[:user_id]))
          @user = User.find(params[:user_id])
          @first_date = @user.event_occurrences.joins(:event).where('events.host_id = ? AND event_occurrences.date >= ?', params[:id], Date.today).order(date: 'ASC')
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
          your_first_date = User.find(params[:user_id]).event_occurrences.joins(:event).where('events.host_id = ? AND event_occurrences.date >= ?', params[:id], Date.today).order(date: 'ASC')
          friend_first_date = User.find(params[:compare_id]).event_occurrences.joins(:event).where('events.host_id = ? AND event_occurrences.date >= ?', params[:id], Date.today).order(date: 'ASC')

          # render json: {your:your_first_date,friend:friend_first_date}
          # return

          if your_first_date.empty? && friend_first_date.empty?
            @first_date = Date.today
          elsif your_first_date.empty?
            @first_date = friend_first_date.first.date
          elsif friend_first_date.empty?
            @first_date = your_first_date.first.date
          else
            @first_date = your_first_date.first.date < friend_first_date.first.date ? your_first_date.first.date : friend_first_date.first.date
          end

          # @first_date = @first_date.empty? ? Date.today : @first_date.first.date.to_date
          @festival = User.find params[:id]
      else
          flash[:danger] = "You do not have permission to view this page."
          redirect_to root_path
      end
  end

  def get_friend_events


      entries = User.find(params[:user_id]).event_occurrences.joins(:event).where('events.host_id' => params[:id])

    events = []
    entries.each do |entry|
      events << {:id => entry.event_id, :title => entry.event.name, :start => entry.date, :end => (entry.date + entry.event.duration.minutes), textColor: 'rgb(6,22,62)', backgroundColor:'rgb(129,239,188)', url:addevent_path(entry), className:'friend-event'}
    end
    render :json => events
  end

  def compare_events
    entries = User.find(params[:user_id]).event_occurrences.joins(:event).where('events.host_id' => params[:id])

    events = []
    entries.each do |entry|
      events << {:id => entry.event_id, :title => entry.event.name, :start => entry.date, :end => (entry.date + entry.event.duration.minutes), backgroundColor: 'rgb(6,22,62)', textColor:'rgb(129,239,188)', url:deleteevent_path(entry), className:'my-event'}
    end
    render :json => events
  end

end
