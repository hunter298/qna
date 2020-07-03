module HasLinks
  extend ActiveSupport::Concern
  included do
    has_many :links, dependent: :destroy, as: :linkable, inverse_of: :linkable

    accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  end
end