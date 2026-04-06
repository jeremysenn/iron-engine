class ExercisesController < ApplicationController
  before_action :find_exercise, only: %i[show edit update]

  def index
    @exercises = KiloExercise.available_for(Current.user).order(:category, :name)
    @categories = @exercises.group_by(&:category)
  end

  def show
  end

  def new
    @exercise = KiloExercise.new(custom: true)
  end

  def create
    @exercise = KiloExercise.new(exercise_params)
    @exercise.custom = true
    @exercise.user = Current.user

    if @exercise.save
      redirect_to exercise_path(@exercise), notice: "Exercise created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @exercise.update(exercise_params)
      redirect_to exercise_path(@exercise), notice: "Exercise updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def find_exercise
    @exercise = KiloExercise.find(params[:id])
  end

  def exercise_params
    params.require(:kilo_exercise).permit(:name, :category, :equipment, :grip_type, :grip_width)
  end
end
