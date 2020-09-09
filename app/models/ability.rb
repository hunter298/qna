# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end


  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Subscription]
    can :update, [Question, Answer, Comment], user_id: user.id
    can :destroy, [Question, Answer, Comment, Subscription], user_id: user.id
    can :upvote, [Question, Answer]
    cannot :upvote, [Question, Answer], user_id: user.id
    can :downvote, [Question, Answer]
    cannot :downvote, [Question, Answer], user_id: user.id
    can :best, Answer, question_id: user.question_ids
    can :destroy, ActiveStorage::Attachment do |attachment|
      user.author_of?(attachment.record)
    end
  end

  def guest_abilities
    can :read, :all
    can :oauth_email_confirmation, User
  end
end
