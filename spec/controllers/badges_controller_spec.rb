require 'rails_helper'

RSpec.describe BadgesController, type: :controller do
  let(:user) { create(:user) }
  let(:questions) { create_list(:question, 3, user: user) }
  let!(:badges) do
    user.badges.push(Badge.create([{ name: 'first', question: questions[0] },
                                   { name: 'second', question: questions[1] },
                                   { name: 'third', question: questions[2] }]))
  end

  describe 'GET#Index' do
    before do
      login(user)
      get :index
    end

    it "populates array of user's badges" do
      expect(assigns(:badges)).to match_array(badges)
    end
  end
end
