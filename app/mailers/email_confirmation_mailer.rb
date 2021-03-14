# frozen_string_literal: true

class EmailConfirmationMailer < ApplicationMailer
  def send_confirmation(email, token)
    @email = email
    @token = token

    mail(to: email, subject: 'QNA email confirmation')
  end
end
