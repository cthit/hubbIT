class StatsController < ApplicationController

  before_action :set_user
  def index
    @sessions = UserSession.group(:user_id)
    @total_time = UserSession.total_time
  end


  def hours
    query = HourEntry.group(:hour)
    query = query.with_user(@user.cid) if params[:user_id]
    render json: query.count
  end

  def show
    @user_sessions = UserSession.with_user(@user).order("-created_at")
    @session = @user_sessions.first
    @longest_session = @user_sessions.maximum('TIME_TO_SEC(end_time) - TIME_TO_SEC(start_time)')

    if @session.present?
      @last_session_duration = @session.end_time - @session.start_time

      @total_time = @user_sessions.select('sum(TIMESTAMPDIFF(SECOND, `start_time`, `end_time`)) as total_time')
      .order("total_time DESC")
      .first().total_time
    end
  end

  private
    def set_user
      if params[:user_id]
        @user = User.find(params[:user_id])
      else
        @user = current_user
      end
    end
end
