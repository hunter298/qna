class SearchesController < ApplicationController
  SEARCH_CLASSES = %w[Question Answer Comment User].freeze

  skip_authorization_check
  skip_before_action :authenticate_user!

  def search
    query = params[:query]
    query_class = params[:query_class] if SEARCH_CLASSES.include?(params[:query_class])
    search_class = query_class.present? ? query_class.constantize : ThinkingSphinx
    @results = (search_class.search ThinkingSphinx::Query.escape(query)).page(params[:page]).per(10)
  end
end
