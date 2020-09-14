require 'sphinx_helper'

feature 'user can search for entries', %q{
in order to find interesting entries by keyword
as an visitor of site
I want to be able to use full-text search
# } do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user, title: 'Keyword_question') }
  given!(:answer) { create(:answer, user: user, question: question, body: 'Keyword_answer') }

  background do
    question.comments.create(user: user, body: 'Keyword_question_comment')
    answer.comments.create(user: user, body: 'Keyword_answer_comment')
  end

  context 'user tries to search everywhere' do
    scenario 'user searches for question everywhere', sphinx: true do
      ThinkingSphinx::Test.run do
        visit root_path
        fill_in 'query', with: question.title
        click_button 'Search'
        expect(page).to have_link question.title
      end
    end

    scenario 'user searches for answer', sphinx: true do
      ThinkingSphinx::Test.run do
        visit root_path
        fill_in 'query', with: answer.body
        click_button 'Search'
        expect(page).to have_link answer.body
      end
    end

    scenario 'user searches for comment', sphinx: true do
      ThinkingSphinx::Test.run do
        visit root_path
        fill_in 'query', with: 'Keyword_question_comment'
        click_button 'Search'
        expect(page).to have_link 'Keyword_question_comment'
      end
    end

    scenario 'user searches for user', sphinx: true do
      ThinkingSphinx::Test.run do
        visit root_path
        fill_in 'query', with: user.email
        click_button 'Search'
        expect(page).to have_link user.email
      end
    end
  end

  context 'user tries to search among questions' do
    scenario 'for question', sphinx: true do
      ThinkingSphinx::Test.run do
        visit root_path
        select 'Question', from: 'query_class'
        fill_in 'query', with: question.title
        click_button 'Search'
        expect(page).to have_link question.title
      end
    end

    scenario 'for answer', sphinx: true do
      ThinkingSphinx::Test.run do
        visit root_path
        select 'Question', from: 'query_class'
        fill_in 'query', with: answer.body
        click_button 'Search'
        expect(page).to_not have_link answer.body
      end
    end
  end

  context 'user tries to search among answers' do
    scenario 'for answer', sphinx: true do
      ThinkingSphinx::Test.run do
        visit root_path
        select 'Answer', from: 'query_class'
        fill_in 'query', with: answer.body
        click_button 'Search'
        expect(page).to have_link answer.body
      end
    end

    scenario 'for comment', sphinx: true do
      ThinkingSphinx::Test.run do
        visit root_path
        select 'Answer', from: 'query_class'
        fill_in 'query', with: 'Keyword_answer_comment'
        click_button 'Search'
        expect(page).to_not have_link 'Keyword_answer_comment'
      end
    end
  end

  context 'user tries to search among comments' do
    scenario 'for comment', sphinx: true do
      ThinkingSphinx::Test.run do
        visit root_path
        select 'Comment', from: 'query_class'
        fill_in 'query', with: 'Keyword_question_comment'
        click_button 'Search'
        expect(page).to have_link 'Keyword_question_comment'
      end
    end

    scenario 'for user', sphinx: true do
      ThinkingSphinx::Test.run do
        visit root_path
        select 'Comment', from: 'query_class'
        fill_in 'query', with: user.email
        click_button 'Search'
        expect(page).to_not have_link user.email
      end
    end
  end

  context 'user tries to search among users' do
    scenario 'for user', sphinx: true do
      ThinkingSphinx::Test.run do
        visit root_path
        select 'User', from: 'query_class'
        fill_in 'query', with: user.email
        click_button 'Search'
        expect(page).to have_link user.email
      end
    end

    scenario 'for comment', sphinx: true do
      ThinkingSphinx::Test.run do
        visit root_path
        select 'User', from: 'query_class'
        fill_in 'query', with: 'Keyword_answer_comment'
        click_button 'Search'
        expect(page).to_not have_link 'Keyword_answer_comment'
      end
    end
  end
end