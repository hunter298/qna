require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'admin abilities' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'user abilities' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }

    before do
      question.files.attach(io: File.new("#{Rails.root}/tmp/test-file.txt", 'w+'), filename: 'test-file.txt')
      answer.files.attach(io: File.new("#{Rails.root}/tmp/test-file.txt", 'w+'), filename: 'test-file.txt')
    end

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }
    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to :update, create(:question, user: user), user: user }
    it { should_not be_able_to :update, create(:question, user: other), user: user }
    it { should be_able_to :update, create(:answer, user: user, question: question), user: user }
    it { should_not be_able_to :update, create(:answer, user: other, question: question), user: user }
    it { should be_able_to :destroy, create(:question, user: user), user: user }
    it { should_not be_able_to :destroy, create(:question, user: other), user: user }
    it { should_not be_able_to :upvote, create(:question, user: user), user: user }
    it { should be_able_to :upvote, create(:question, user: other), user: user }
    it { should_not be_able_to :downvote, create(:question, user: user), user: user }
    it { should be_able_to :downvote, create(:question, user: other), user: user }
    it { should_not be_able_to :destroy, create(:question, user: other), user: user }
    it { should be_able_to :destroy, question.files.first, user: user }
    it { should be_able_to :destroy, answer.files.first, user: user }
    it { should be_able_to :best, create(:answer, question: question, user: other), user: user }
  end

  describe 'guest abilities' do
    let(:user) { build(:user) }
    it { should be_able_to :oauth_email_confirmation, User, user: user }
  end
end
