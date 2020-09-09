require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to :user }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_one(:badge).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should accept_nested_attributes_for :links }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it 'has many attached file' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe "#upvote" do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'should increase rating by 1' do
      question.upvote(user)

      expect(question.rating).to eq 1
    end

    it 'should not change rating after two applying' do
        question.upvote(user)
        question.upvote(user)

        expect(question.rating).to eq 0
    end
  end

  describe "#downvote" do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'should decrease rating by 1' do
      question.downvote(user)

      expect(question.rating).to eq -1
    end

    it 'should not change rating after two applying' do
        question.downvote(user)
        question.downvote(user)

        expect(question.rating).to eq 0
    end
  end
end

