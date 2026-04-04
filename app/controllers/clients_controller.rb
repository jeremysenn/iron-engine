class ClientsController < ApplicationController
  include Scopeable

  before_action :find_client, only: %i[show edit update destroy]

  def index
    @clients = scoped_clients.order(:last_name, :first_name)
  end

  def show
    @assessments = @client.prime_eight_assessments.order(assessed_at: :desc)
    @map_assessments = @client.map_assessments.order(assessed_at: :desc)
    @active_program = @client.active_program
  end

  def new
    @client = scoped_clients.build
  end

  def create
    @client = scoped_clients.build(client_params)

    if @client.save
      redirect_to @client, notice: "Client added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @client.update(client_params)
      redirect_to @client, notice: "Client updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @client.destroy
    redirect_to clients_path, notice: "Client removed."
  end

  private

  def client_params
    params.require(:client).permit(:first_name, :last_name, :training_age, :date_of_birth, :notes)
  end
end
