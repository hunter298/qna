require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  describe 'POST#Create' do
    let(:author) { create(:user) }
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: author) }

    context 'authorized user' do
      before { login(user) }

      it 'creates new subscription' do
        expect { post :create, params: { question_id: question } }.to change(Subscription, :count).by(1)
      end
    end

    context 'unauthorized user' do
      it 'does not create new subscription' do
        expect { post :create, params: { question_id: question } }.to_not change(Subscription, :count)
      end
    end
  end

  
end