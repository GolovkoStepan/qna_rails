# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]

  include OpportunityToVote

  def index
    @questions = Question.all
  end

  def show; end

  def new
    return head(403) unless current_user.confirmed?

    @question = Question.new
    @question.reward = Reward.new
  end

  def create
    return head(403) unless current_user.confirmed?

    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question
    else
      flash[:alert] = 'There were errors during creation. Check again if you entered everything correctly.'
      render :new
    end
  end

  def edit; end

  def update
    return head(403) unless current_user.created_by_me?(@question)
    return unless @question.update(question_params.except(:files))

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
    params.require(:question).permit(
      :title, :body,
      files: [],
      links_attributes: %i[id name url _destroy],
      reward_attributes: %i[name image]
    )
  end
end
