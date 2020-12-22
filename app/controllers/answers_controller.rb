# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!

  before_action :load_answer, only: %i[destroy update mark_as_accepted]
  before_action :load_question, only: %i[create]

  def create
    @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def update
    return head(403) unless current_user.created_by_me?(@answer)

    @answer.update(answer_params)
  end

  def destroy
    return head(403) unless current_user.created_by_me?(@answer)

    @answer.destroy
    head 200
  end

  def mark_as_accepted
    return head(403) unless current_user.created_by_me?(@answer.question)

    @answer.mark_as_accepted
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
