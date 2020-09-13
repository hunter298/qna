class SearchesController < ApplicationController
  skip_authorization_check

  def search
    query = params[:query]
    query_class = params[:query_class]
    search_class = query_class.present? ? query_class.constantize : ThinkingSphinx
    @results = (search_class.search ThinkingSphinx::Query.escape(query)).page(params[:page]).per(10)
  end
end