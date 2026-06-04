class ExercisesController < ApplicationController
  before_action :find_exercise, only: %i[show]
  before_action :find_owned_exercise, only: %i[edit update destroy]

  def index
    @exercises = KiloExercise.available_for(Current.user).order(:body_region, :category, :subcategory, :name)
    # Group by body_region -> category
    @grouped = @exercises.group_by(&:body_region)
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

  def destroy
    if @exercise.destroy
      redirect_to exercises_path, notice: "Exercise deleted."
    else
      # dependent: :restrict_with_error blocks deletion while the exercise is
      # still assigned to programs. Tell the coach to swap it out first.
      count = @exercise.session_exercises.count
      redirect_to exercise_path(@exercise),
        alert: "Can't delete — in use by #{count} #{'session'.pluralize(count)}. Swap it out of those first."
    end
  end

  private

  def find_exercise
    @exercise = KiloExercise.available_for(Current.user).find(params[:id])
  end

  # Edit/update/destroy are limited to the coach's own custom exercises.
  # Standard KILO exercises and other coaches' customs are read-only.
  def find_owned_exercise
    @exercise = KiloExercise.custom_for(Current.user).find_by(id: params[:id])
    return if @exercise

    redirect_to exercises_path, alert: "You can only edit or delete your own custom exercises."
  end

  def exercise_params
    params.require(:kilo_exercise).permit(:name, :body_region, :category, :subcategory, :equipment, :grip_type, :grip_width, :video_url)
  end
end
