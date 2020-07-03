module Ratable
  extend ActiveSupport::Concern

  included do
    def upvote
      self.update(rating: (self.rating += 1))
    end

    def downvote

    end
  end
end