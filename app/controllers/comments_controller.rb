# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_commentable

  def new
    @comment = @commentable.comments.new
  end

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.save
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(user_id: current_user.id)
  end

  def find_commentable
    params.each do |key, value|
      if key.to_s.end_with? '_id'
        @commentable = key.split('_').first.classify.constantize.find(value)
        break
      end
    end
  end
end
