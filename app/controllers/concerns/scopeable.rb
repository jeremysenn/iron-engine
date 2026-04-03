module Scopeable
  extend ActiveSupport::Concern

  private

  def scoped_clients
    Current.user.clients
  end

  def find_client
    @client = scoped_clients.find(params[:client_id] || params[:id])
  end
end
