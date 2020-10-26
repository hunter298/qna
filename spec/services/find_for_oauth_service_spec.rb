require 'rails_helper'

RSpec.describe FindForOauthService do
  let!(:user) { create(:user) }
  let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345') }
  subject { FindForOauthService.new(auth) }

  context 'user already has authorization' do
    it 'returns user' do
      user.authorizations.create(provider: 'facebook', uid: '12345')
      expect(subject.call).to eq user
    end
  end

  context 'user has not authorization' do
    let(:auth) do
      OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345',
                             info: { email: user.email })
    end
    context 'user already exists' do
      it 'does not create new user' do
        expect { subject.call }.to_not change(User, :count)
      end

      it 'creates authorization for user' do
        expect { subject.call }.to change(user.authorizations, :count).by(1)
      end

      it 'creates authorization with provider and uid' do
        user = subject.call
        authorization = user.authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end

      it 'returns the user' do
        expect(subject.call).to eq user
      end
    end

    context 'user does not exist' do
      let(:auth) do
        OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345',
                               info: { email: 'some@new.email' })
      end

      it 'creates new user' do
        expect { subject.call }.to change(User, :count).by(1)
      end

      it 'returns new user' do
        expect(subject.call).to be_a(User)
      end

      it 'fills user email' do
        expect(subject.call.email).to eq auth.info[:email]
      end

      it 'creates authorization for user' do
        expect(subject.call.authorizations).to_not be_empty
      end

      it 'creates authorization with provider and uid' do
        user = subject.call
        authorization = user.authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end
    end
  end
end
