require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many :badges }
  it { should have_many :comments }
  it { should have_many(:authorizations).dependent(:destroy)}

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

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345') }
    let(:service) { double('FindForOauth') } #mock object

    it 'call find_for_oauth_service' do
      expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end
