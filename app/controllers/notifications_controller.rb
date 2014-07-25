class NotificationsController < ApplicationController
  before_filter :set_year, only: [:index]

  def index
    @notifications = Notification
      .includes(:notification_instances)
      .includes(:payments)
      .all
      .decorate
  end

  def edit
    @notification = Notification.find(params[:id]).decorate
    render :form
  end

  def new
    @notification = Notification.new.decorate
    render :form
  end

  def update
    params.require(:notification).permit!
    ns_params = params[:notification].delete(:notification_samples_attributes)
    @notification = Notification.find(params[:id]).decorate
    @notification.update_attributes(params[:notification])
    if @notification.valid?
      redirect_to action: :index
    else
      flash[:error] = @notification.errors.messages
      render :form
    end
  end

  def create
    params.require(:notification).permit!
    binding.pry
    @notification = Notification.new(params[:notification]).decorate
    if @notification.save
      redirect_to action: :index
    else
      flash[:error] = @notification.errors.messages
      render :form
    end
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
