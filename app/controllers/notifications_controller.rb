class NotificationsController < ApplicationController
  before_filter :set_year, only: [:index]

  def index
  end

  def new
  end

  def create
  end

  def set_paid
  end

  def set_year
    if y = params[:year]
      session[:year] = y
    end
    @year = session[:year] || Time.current.year
  end
end
