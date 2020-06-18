require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question}
  it { should belong_to :user}

  it { should validate_presence_of :body }

  describe "Answer#is_best!" do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answers) { create_list(:answer, 3, question: question, user: user) }

    it 'makes answer best' do
      answers[0].is_best!

      expect(answers[0].best).to be_truthy
    end

    it 'makes all other answer not best' do
      answers.each { |answer| answer.is_best! }

      expect(answers[0].reload.best).to be_falsey
      expect(answers[1].reload.best).to be_falsey
      expect(answers[2].reload.best).to be_truthy
    end
  end
end
