require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should validate_presence_of :body }
  it { should belong_to :commentable }
  it { should belong_to :user }

  describe '#commentable' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:comment) { question.comments.create(user: user) }

    it 'return commented object' do
      expect(comment.commentable).to eq question
    end
  end
end
