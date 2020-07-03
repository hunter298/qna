require 'rails_helper'

feature 'user can rate questions or answers', %q{
in order to promote best questions or answers
as an authenticated user
I'd like to able to upvote or downvote them
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'authenticated user' do
    background do
      sign_in(create(:user))
      visit question_path(question)
    end

    scenario "tries to upvote other's user question" do
      click_link('Upvote')
      expect(question.reload.rating).to eq 1
    end
  end
end