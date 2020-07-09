module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy

    def upvote(user)
      if vote = votes.find_by(user: user)
        vote.useful == 1 ? vote.destroy : vote.update(useful: 1)
      else
        votes.create(user: user, useful: 1)
      end
    end

    def downvote(user)
      if vote = votes.find_by(user: user)
        vote.useful == -1 ? vote.destroy : vote.update(useful: -1)
      else
        votes.create(user: user, useful: -1)
      end
    end

    def rating
      votes.sum(:useful)
    end
  end
end