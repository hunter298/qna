require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question}
  it { should belong_to :user}
  it { should have_many(:links).dependent(:destroy) }

  it { should accept_nested_attributes_for :links }

  it { should validate_presence_of :body }

  it 'has many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe "Answer#is_best!" do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answers) { create_list(:answer, 2, question: question, user: user) }

    it 'makes answer best' do
      answers[0].is_best!

      expect(answers[0].best).to be_truthy
    end

    it 'makes all other answer not best' do
      answers.each { |answer| answer.is_best! }

      expect(answers[0].reload.best).to be_falsey
    end


    context 'question with few answers' do
      it 'should have only one best answer' do
        answers[0].is_best!
        answers[1].is_best!
        expect(question.answers.select { |answer| answer.best }.count).to eq 1
      end
    end
  end
end
