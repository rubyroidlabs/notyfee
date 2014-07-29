class NotificationsController < ApplicationController
  before_filter :set_year, only: [:index]

  def index
    @notifications = Notification
      .order(:created_at)
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
    @notification = Notification.find(params[:id]).decorate
    if @notification.update_attributes(notification_params)
      redirect_to action: :index
    else
      flash[:error] = @notification.errors_flash_content
      render :form
    end
  end

  def create
    @notification = Notification.new(notification_params).decorate
    if @notification.save
      redirect_to action: :index
    else
      flash[:error] = @notification.errors_flash_content
      render :form
    end
  end

  def destroy
    @notification = Notification.find(params[:id]).destroy
    redirect_to action: :index
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

private

  def set_year
    if y = params[:year]
      session[:year] = y
    end
    @year = session[:year] || Time.current.year
  end

  def notification_params
    params.require(:notification).permit(
      :notification, :name, :title, :to, :text, :year_month, :timezone,
      notification_samples_attributes: [
        :id, :notification_id, :datetime_local
      ])
  end
end
