class Api::V1::BaseController < ApplicationController
  before_action :doorkeeper_authorize!
  skip_authorization_check
  skip_before_action :authenticate_user!

  private

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end