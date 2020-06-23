require 'rails_helper.rb'

feature 'user can delete attached files', %{
in order to delete wrong or redundant file
I, as an author of question or answer to which it attached
want to be able to delete it
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  background do
    question.files.attach(io: File.new("#{Rails.root}/tmp/test-file1.txt", "w+"), filename: 'test-file1.txt')
    answer.files.attach(io: File.new("#{Rails.root}/tmp/test-file2.txt", "w+"), filename: 'test-file2.txt')
  end

  describe 'authenticated user' do
    context 'as author' do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'tries to delete some files attached to question', js: true do
        within('.question-files') do
          click_on 'Delete file'

          expect(page).to_not have_content 'test-file1.txt'
        end
      end

      scenario 'tries to delete some files attached to answer', js: true do
        within('.answer-files') do
          click_on 'Delete file'

          expect(page).to_not have_content 'test-file2.txt'
        end
      end
    end

    context 'not an author' do
      background do
        sign_in(create(:user))
        visit question_path(question)
      end

      scenario 'tries to delete some files attached to question' do
        within('.question-files') do
          expect(page).to_not have_link 'Delete file'
        end
      end

      scenario 'tries to delete some files attached to answer' do
        within('.answer-files') do
          expect(page).to_not have_link 'Delete file'
        end
      end
    end
  end

  describe 'unauthenticated user' do
    scenario 'tries to delete files from quesiton or answer' do
      visit question_path(question)

      expect(page).to_not have_content 'Delete file'
    end
  end
end