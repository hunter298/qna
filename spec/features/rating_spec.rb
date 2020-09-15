require 'rails_helper'

feature 'user can vote for best questions' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:other_question) { create(:question, user: create(:user)) }

  context 'authorized user' do
    background do
      sign_in(user)
    end

    scenario "tries to upvote other user's question", js: true do
      visit question_path(other_question)

      click_on "upvote-question"

      expect(other_question.rating).to eq 1
    end

    scenario "tries to downvote other user's question", js: true do
      visit question_path(other_question)

      click_on "downvote-question"

      expect(other_question.rating).to eq -1
    end

    scenario "tries to upvote other user's question twice", js: true do
      visit question_path(other_question)

      click_on "upvote-question"
      visit current_path
      click_on "upvote-question"

      expect(other_question.rating).to eq 0
    end

    scenario "tries to downvote other user's question twice", js: true do
      visit question_path(other_question)

      click_on "downvote-question"
      visit current_path
      click_on "downvote-question"
      visit current_path
      expect(other_question.rating).to eq 0
    end

    scenario 'tries to downvote question after upvoting', js: true do
      visit question_path(other_question)

      click_on "upvote-question"
      click_on "downvote-question"

      expect(other_question.rating).to eq (-1)
    end

    scenario 'tries to upvote question after downvoting', js: true do
      visit question_path(other_question)

      click_on "downvote-question"
      click_on "upvote-question"
      visit current_path
      expect(other_question.rating).to eq (1)
    end

    scenario 'tries to upvote own quesiton' do
      visit question_path(question)

      expect(page).to_not have_link "\u2B06"
    end

    scenario 'tries to downvote own quesiton' do
      visit question_path(question)

      expect(page).to_not have_link "\u2B07"
    end
  end

  context 'anauthorized user' do
    scenario "tries to upvote other user's question", js: true do
      visit question_path(question)

      click_on "upvote-question"

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
      expect(question.rating).to eq 0
    end

    scenario "tries to downvote other user's question", js: true do
      visit question_path(question)

      click_on "downvote-question"

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
      expect(question.rating).to eq 0
    end
  end

  scenario 'user should see final rating of question', js: true do
    sign_in(user)
    visit question_path(other_question)

    click_on "upvote-question"
    click_on "Log out"

    sign_in(create(:user))
    visit question_path(other_question)

    click_on "upvote-question"

    expect(page).to have_selector('.question-rating-counter', exact_text: '2')
  end
end

feature 'user can vote for best answers' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: create(:user)) }
  given!(:own_answer) { create(:answer, question: question, user: user) }

  context 'authorized user' do
    background do
      sign_in(user)
    end

    scenario "tries to upvote other user's answer", js: true do
      visit question_path(question)

      within("#answer-#{answer.id}") do
        click_on "\u2B06"
      end
      visit current_path
      expect(answer.rating).to eq 1
    end

    scenario "tries to downvote other user's answer", js: true do
      visit question_path(question)

      within("#answer-#{answer.id}") do
        click_on "\u2B07"
      end

      expect(answer.rating).to eq -1
    end

    scenario "tries to upvote other user's answer twice", js: true do
      visit question_path(question)

      within("#answer-#{answer.id}") do
        click_on "\u2B06"
        visit current_path
        click_on "\u2B06"
      end

      expect(answer.rating).to eq 0
    end

    scenario "tries to downvote other user's answer twice", js: true do
      visit question_path(question)

      within("#answer-#{answer.id}") do
        click_on "\u2B07"
        visit current_path
        click_on "\u2B07"
        visit current_path
      end

      expect(answer.rating).to eq 0
    end

    scenario 'tries to downvote answer after upvoting', js: true do
      visit question_path(question)

      within("#answer-#{answer.id}") do
        click_on "\u2B06"
        click_on "\u2B07"
      end

      expect(answer.rating).to eq (-1)
    end

    scenario 'tries to upvote answer after downvoting', js: true do
      visit question_path(question)

      within("#answer-#{answer.id}") do
        click_on "\u2B07"
        visit current_path
        click_on "\u2B06"
      end

      expect(answer.rating).to eq (1)
    end

    scenario 'tries to upvote own answer' do
      visit question_path(question)

      within("#answer-#{own_answer.id}") do
        expect(page).to_not have_link "\u2B06"
      end
    end

    scenario 'tries to downvote own answer' do
      visit question_path(question)

      within("#answer-#{own_answer.id}") do
        expect(page).to_not have_link "\u2B07"
      end
    end
  end

  context 'anauthorized user' do
    scenario "tries to upvote other user's answer", js: true do
      visit question_path(question)

      within("#answer-#{answer.id}") do
        click_on "\u2B06"
      end

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
      expect(answer.rating).to eq 0
    end

    scenario "tries to downvote other user's answer", js: true do
      visit question_path(question)

      within("#answer-#{answer.id}") do
        click_on "\u2B07"
      end

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
      expect(answer.rating).to eq 0
    end
  end

  scenario 'user should see final rating of answer', js: true do
    sign_in(user)
    visit question_path(question)

    within("#answer-#{answer.id}") do
      click_on "\u2B06"
    end
    click_on "Log out"

    sign_in(create(:user))
    visit question_path(question)

    within("#answer-#{answer.id}") do
      click_on "\u2B06"
    end

    expect(page).to have_selector(".answer-#{answer.id}-rating-counter", exact_text: '2')
  end
end