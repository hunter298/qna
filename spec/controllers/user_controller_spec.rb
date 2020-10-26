require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'POST#oauth_email_confirmation' do
    before do
      session[:provider] = 'provider'
      session[:uid] = '12345'
    end

    context 'new email' do
      it 'creates new user' do
        expect { post :oauth_email_confirmation, params: { email: 'test@example.com' } }.to change(User, :count).by(1)
      end

      it 'creates new authorization' do
        expect { post :oauth_email_confirmation, params: { email: 'test@example.com' } }.to change(Authorization, :count).by(1)
      end

      it 'redirects to root path in case of successfull registration' do
        post :oauth_email_confirmation, params: { email: 'test@example.com' }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'existed email' do
      let!(:user) { create(:user, email: 'test@example.com') }

      it 'does not create new user' do
        expect { post :oauth_email_confirmation, params: { email: 'test@example.com' } }.to_not change(User, :count)
      end

      it 'does not create new authorization' do
        expect { post :oauth_email_confirmation, params: { email: 'test@example.com' } }.to_not change(Authorization, :count)
      end

      it 'render page again with error message' do
        post :oauth_email_confirmation, params: { email: 'test@example.com' }
        expect(response).to render_template('shared/facebook_email')
      end
    end
  end
end
