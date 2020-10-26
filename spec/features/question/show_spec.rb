require 'rails_helper'

feature 'user can view the question to find desired answer', '
in order to find answers for similar question
any user visiting site
should can view the question along with given answers
' do
  given!(:user) { create(:user) }
  given!(:questions) { create_list(:question, 5, user: user) }
  given!(:answers) { create_list(:answer, 3, question: questions[3], user: user) }

  background do
    sign_in(user)
    visit questions_path
    click_on questions[3].title
  end

  scenario 'user tries to view questions from list' do
    expect(page).to have_content questions[3].title
    expect(page).to have_content questions[3].body

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end

  scenario 'user tries to add answer from question page', js: true do
    fill_in 'answer_body', with: 'Some answer'
    click_on 'Create Answer'

    expect(page).to have_content 'Some answer'
  end
end
