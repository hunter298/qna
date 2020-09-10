require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  describe 'POST#Create' do
    let(:author) { create(:user) }
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: author) }

    context 'authorized user' do
      before { login(user) }

      it 'creates new subscription' do
        expect { post :create, params: { question_id: question }, format: :json }.to change(Subscription, :count).by(1)
      end

      it 'does not redirect anyway' do
        post :create, params: { question_id: question }, format: :json
        expect(response.status).to_not eq 302
      end

      it 'does not create second subscription if called twice' do
        expect do
          post :create, params: { question_id: question }, format: :json
          post :create, params: { question_id: question }, format: :json
        end.to change(Subscription, :count).by(1)
      end
    end

    context 'unauthorized user' do
      it 'does not create new subscription' do
        expect { post :create, params: { question_id: question } }.to_not change(Subscription, :count)
      end
    end
  end

  describe 'DELETE#Destroy' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:subscription) { create(:subscription, user: user, question: question) }

    context 'authorized user' do
      before { login(user) }

      context 'has subscription' do
        it 'destroys subscription' do
          expect {delete :destroy, params: { id: subscription }, format: :json}.to change(Subscription, :count).by(-1)
        end

        it 'does not redirect anyway' do
          delete :destroy, params: { id: subscription }, format: :json
          expect(response.status).to_not eq 302
        end
      end
    end

    context 'unauthorized user' do
      it 'does not delete subscription' do
        expect { delete :destroy, params: { id: subscription } }.to_not change(Subscription, :count)
      end
    end
  end
end