module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy

    def upvote(user)
      if vote = Vote.find_by(user: user, votable: self)
        if vote.useful
          vote.destroy
          self.rating -= 1
          save
        else
          vote.update(useful: true)
          self.rating += 2
          save
        end
      else
        Vote.create(user: user, votable: self, useful: true)
        self.rating += 1
        save
      end
    end

    def downvote(user)
      if vote = Vote.find_by(user: user, votable: self)
        if !vote.useful
          vote.destroy
          self.rating += 1
          save
        else
          vote.update(useful: false)
          self.rating -= 2
          save
        end
      else
        Vote.create(user: user, votable: self, useful: false)
        self.rating -= 1
        save
      end
    end
  end
end