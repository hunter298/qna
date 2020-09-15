require 'rails_helper'

feature 'user can create achievement', %q{
in order to motivate other user to answer my question
as an author of question
I'd like to be able to create badge for best answer
} do

  describe 'authenticated user' do
    given(:user) { create(:user) }

    scenario 'tries to add badge creating question' do
      sign_in(user)
      visit new_question_path

      fill_in 'Title', with: 'Question title'
      fill_in 'Body', with: 'Some text'

      fill_in 'Badge name', with: 'New badge'
      attach_file 'question_badge_attributes_icon', "#{Rails.root}/app/assets/images/gold.jpg"
      click_on 'Create Question'

      expect(Question.last.badge.name).to eq 'New badge'
    end
  end

  describe "question's author" do
    given(:user) { create(:user) }
    given!(:question) { create(:question, user: user) }
    given!(:badge) { create(:badge, question: question) }

    given(:other_user) { create(:user) }
    given!(:answer) { create(:answer, question: question, user: other_user) }

    scenario "flag some answer as best", js: true do
      expect do
        sign_in(user)
        visit question_path(question)

        click_link 'Best'
        visit current_path
      end.to change(other_user.badges, :count).by(1)
    end
  end
end