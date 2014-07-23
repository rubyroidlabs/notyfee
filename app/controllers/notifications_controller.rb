class NotificationsController < ApplicationController
  before_filter :set_year, only: [:index]

  def index
    @notifications = Notification
      .includes(:notification_instances)
      .includes(:payments)
      .all
      .decorate
  end

  def new
  end

  def create
  end

  def toggle_paid
    @notification = Notification.find(params[:id])
    payment = @notification.payments
      .where(month_offset: params[:offset])
      .first_or_initialize
    if payment.persisted?
      payment.destroy
    else
      payment.save!
    end
    redirect_to action: :index
  end

  def set_year
    if y = params[:year]
      session[:year] = y
    end
    @year = session[:year] || Time.current.year
  end
end
