# frozen_string_literal: true

module ApplicationHelper
  def format_date(datetime)
    datetime.strftime('%d.%m.%Y %H:%M:%S')
  end
end
