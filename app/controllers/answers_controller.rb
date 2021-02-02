# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!

  before_action :load_answer, only: %i[destroy edit update mark_as_accepted]
  before_action :load_question, only: %i[new create]

  def create
    @answer = @question.answers.build(answer_params.merge(user: current_user))
    @answer.save
  end

  def edit; end

  def update
    return head(403) unless current_user.created_by_me?(@answer)
    return unless @answer.update(answer_params.except(:files))

    answer_params[:files].each { |file| @answer.files.attach(file) } if answer_params[:files]&.any?
  end

  def destroy
    return head(403) unless current_user.created_by_me?(@answer)

    @answer.destroy
  end

  def mark_as_accepted
    return head(403) unless current_user.created_by_me?(@answer.question)

    @answer.mark_as_accepted
    @answer.question.give_reward(@answer.user)
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[id name url _destroy])
  end
end
