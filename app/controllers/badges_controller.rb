class BadgesController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize! :read, Badge
    @badges = current_user.badges
  end
end
