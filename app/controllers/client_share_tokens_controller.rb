class ClientShareTokensController < ApplicationController
  include Scopeable

  before_action :find_client

  # POST /clients/:client_id/share_token
  def create
    # Revoke any existing active tokens before creating a new one
    @client.share_tokens.active.each(&:revoke!)
    @client.generate_share_token!

    redirect_to client_path(@client), notice: "Share link generated."
  end

  # DELETE /clients/:client_id/share_token
  def destroy
    @client.share_tokens.active.each(&:revoke!)

    redirect_to client_path(@client), notice: "Share link revoked."
  end
end
