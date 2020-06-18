require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to :user }
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  describe 'question with few answers' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:other_answer) { create(:answer, question: question, user: user) }

    it 'should have only one best answer' do
      answer.is_best!
      other_answer.is_best!
      expect(question.answers.select { |answer| answer.best }.count).to eq 1
    end
  end
end
