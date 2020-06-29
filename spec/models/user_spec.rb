require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:achievements).dependent(:destroy) }
  it { should have_many(:badges).through(:achievements) }

  describe 'User#author_of?' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:other_question) { create(:question, user: other_user) }

    it 'returns true if object is created by user' do
      expect(user).to be_author_of(question)
    end

    it 'returns false if object is not created by user' do
      expect(user.author_of?(other_question)).to be_falsey
    end
  end
end
