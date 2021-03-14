# frozen_string_literal: true

class EmailConfirmationController < ApplicationController
  before_action :authenticate_user!

  def send_email
    if current_user.email.present? && !current_user.email_confirmed
      token = email_confirmation_service.create_token(email: current_user.email)
      EmailConfirmationMailer.send_confirmation(current_user.email, token).deliver_now

      @result = true
    else
      redirect_to edit_user_registration_path
    end
  rescue Services::EmailConfirmation::Errors::TooManyPerHour
    @result = false
  end

  def check_token
    @result = email_confirmation_service.token_equal?(email: current_user.email, token: params[:token])
    return redirect_to(edit_user_registration_path, alert: 'Invalid confirmation token!') unless @result

    current_user.update(email_confirmed: true)
    redirect_to edit_user_registration_path, notice: 'You email address is confirmed!'
  rescue Services::EmailConfirmation::Errors::TokenExpired
    redirect_to edit_user_registration_path, alert: 'Email confirmation token is expired!'
  end

  private

  def email_confirmation_service
    @email_confirmation_service ||= Services::EmailConfirmation::Client.new
  end
end
