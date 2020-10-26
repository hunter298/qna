require 'rails_helper'

feature 'user can choose best answer', "
in order to mark most useful answer
as an author of question
I'd like to be able to flag best answer
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:first_answer) { create(:answer, question: question, user: user) }
  given!(:second_answer) { create(:answer, question: question, user: user) }

  describe 'question author' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'first time tries to mark best', js: true do
      within "#answer-#{first_answer.id}" do
        click_link 'Best'
        visit current_path
        expect(first_answer.reload.best).to be_truthy
        expect(page.find_link('Best')[:class]).to eq 'btn best btn-success'
      end
    end

    scenario 'second time tries to mark best answer', js: true do
      within "#answer-#{first_answer.id}" do
        click_link 'Best'
      end

      within "#answer-#{second_answer.id}" do
        click_link 'Best'
        visit current_path
        expect(first_answer.reload.best).to be_falsey
        expect(second_answer.reload.best).to be_truthy
        expect(page.find_link('Best')[:class]).to eq 'btn best btn-success'
      end

      within "#answer-#{first_answer.id}" do
        expect(page.find_link('Best')[:class]).to eq 'btn best btn-secondary'
      end
    end
  end

  scenario 'other user tries to mark best answer' do
    sign_in(create(:user))
    visit question_path(question)

    expect(page).to_not have_content 'Best'
  end
end
