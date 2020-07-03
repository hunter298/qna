require 'rails_helper'

feature 'user can vote for best questions' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: create(:user)) }

  context 'authorized user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries to upvote question' do
      click_on 'Upvote'

      expect(question.reload.rating).to eq 1
    end
  end
end