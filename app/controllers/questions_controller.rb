# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]

  include OpportunityToVote

  rescue_from Pundit::NotAuthorizedError, with: :authorization_error

  def index
    @questions = Question.all
    authorize @questions
  end

  def show
    authorize @question
  end

  def new
    @question = Question.new
    authorize @question

    @question.reward = Reward.new
  end

  def create
    @question = current_user.questions.new(question_params)
    authorize @question

    if @question.save
      redirect_to @question
    else
      flash[:alert] = 'There were errors during creation. Check again if you entered everything correctly.'
      render :new
    end
  end

  def edit
    authorize @question
  end

  def update
    authorize @question
    return unless @question.update(question_params.except(:files))

    question_params[:files].each { |file| @question.files.attach(file) } if question_params[:files]&.any?
  end

  def destroy
    authorize @question

    @question.destroy
    redirect_to questions_path
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(
      :title, :body,
      files: [],
      links_attributes: %i[id name url _destroy],
      reward_attributes: %i[name image]
    )
  end
end
