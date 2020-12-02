# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!

  before_action :load_answer, only: %i[destroy]
  before_action :load_question, only: %i[create destroy]

  def create
    @answer = @question.answers.new(answer_params.merge(user: current_user))
    @answer.save

    redirect_to question_path(@question)
  end

  def destroy
    redirect_to question_path(@question) unless current_user.created_by_me?(@answer)

    @answer.destroy
    redirect_to question_path(@question)
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
