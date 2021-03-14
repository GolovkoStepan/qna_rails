# frozen_string_literal: true

class PhoneConfirmationController < ApplicationController
  before_action :authenticate_user!

  def send_otp
    if current_user.phone.present? && !current_user.phone_confirmed
      code = otp_service.create_code(number: current_user.phone)
      text = "Your code for phone confirmation on QNA: #{code}"

      sms_service.send_to(number: current_user.phone, text: text)
      @result = true
    else
      redirect_to edit_user_registration_path
    end
  rescue Services::OneTimePassword::Errors::TooManyPerHour
    @result = false
  end

  def check_otp
    @result = otp_service.code_equal?(number: current_user.phone, code: code)
    return unless @result

    current_user.update(phone_confirmed: true)
  rescue Services::OneTimePassword::Errors::CodeExpired
    @result = false
  end

  private

  def sms_service
    @sms_service ||= Services::SmsSender::Client.new
  end

  def otp_service
    @otp_service ||= Services::OneTimePassword::Client.new
  end

  def code
    @code ||= params.dig(:otp_code, :code)
  end
end
