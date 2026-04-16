class SharedController < ApplicationController
  allow_unauthenticated_access
  layout "shared"

  before_action :find_share_token
  before_action :set_client

  # GET /s/:token
  def show
    @program = @client.active_program
    return unless @program

    @program = Program.with_full_structure.find(@program.id)
    @next_session = find_next_session
  end

  private

  def find_share_token
    @share_token = ClientShareToken.find_by(token: params[:token])

    if @share_token.nil? || !@share_token.active?
      render file: Rails.root.join("public/404.html"), layout: false, status: :not_found
    end
  end

  def set_client
    @client = @share_token.client
  end

  def find_next_session
    @program.macrocycles.flat_map { |macro|
      macro.mesocycles.sort_by(&:number).flat_map { |meso|
        meso.microcycles.sort_by(&:week_number).flat_map { |micro|
          micro.training_sessions.sort_by(&:day)
        }
      }
    }.find { |s| !s.logged? }
  end
end
