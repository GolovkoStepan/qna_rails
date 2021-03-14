# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'qna@qna.com'
  layout 'mailer'
end
