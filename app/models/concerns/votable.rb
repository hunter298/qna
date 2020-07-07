module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy

    def upvote(user)
      if vote = votes.find_by(user: user)
        if vote.useful == 1
          vote.destroy
        else
          vote.update(useful: 1)
        end
      else
        votes.create(user: user, useful: 1)
      end
    end

    def downvote(user)
      if vote = votes.find_by(user: user)
        if vote.useful == -1
          vote.destroy
        else
          vote.update(useful: -1)
        end
      else
        votes.create(user: user, useful: -1)
      end
    end

    def rating
      votes.sum(:useful)
    end
  end
end