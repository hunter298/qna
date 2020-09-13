class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  SEARCH_CLASSES = %w[Question Answer Comment User].freeze
end
