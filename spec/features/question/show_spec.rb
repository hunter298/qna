require 'rails_helper'

feature 'user can view the question to find desired answer', %q{
in order to find answers for similar question
any user visiting site
should can view the question along with given answers
} do

  given!(:questions) { create_list(:question, 5) }

  scenario 'user tries to view questions from list' do
    questions[3].answers.create([{body: 'answer1'}, {body: 'answer2'}])

    visit questions_path
    click_on questions[3].title

    expect(page).to have_content questions[3].title
    expect(page).to have_content questions[3].body

    questions[3].answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end

  scenario 'user tries to add answer from question page' do
    visit questions_path
    click_on questions[3].title

    fill_in 'answer_body', with: 'Some answer'
    click_on 'Create Answer'

    expect(page).to have_content 'Some answer'
  end

end