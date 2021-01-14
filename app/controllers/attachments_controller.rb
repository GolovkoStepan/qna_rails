# frozen_string_literal: true

class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    return head 403 unless current_user.created_by_me?(@file.record)

    @file.purge
  rescue ActiveRecord::RecordNotFound
    head 404
  end
end
