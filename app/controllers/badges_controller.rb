class BadgesController < ApplicationController
  before_action :authenticate_user!

  def index
    @badges = current_user.badges
    authorize! :read, @badges
  end
end