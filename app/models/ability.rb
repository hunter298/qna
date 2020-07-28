# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if @user
      @user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end


  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer, Comment], user_id: @user.id
    can :destroy, [Question, Answer, Comment], user_id: @user.id
    can :best, Answer, user_id: @user.id
    can :delete_file_attached, [Question, Answer], user_id: @user.id
    can :upvote, [Question, Answer], user_id: !@user.id
    can :downvote, [Question, Answer], user_id: !@user.id
  end

  def guest_abilities
    can :read, :all
  end
end
