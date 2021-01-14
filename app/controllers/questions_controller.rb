# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  before_action :load_question, only: %i[show update destroy]

  def index
    @questions = Question.all
  end

  def show; end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question
    else
      render :new
    end
  end

  def update
    return head(403) unless current_user.created_by_me?(@question)

    @question.update(question_params.except(:files))
    question_params[:files].each { |file| @question.files.attach(file) } if question_params[:files]&.any?
  end

  def destroy
    return redirect_to(question_path(@question)) unless current_user.created_by_me?(@question)

    @question.destroy
    redirect_to questions_path
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end
end
