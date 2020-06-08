require 'rails_helper'

feature 'user can view the list of questions', %q{
In order to solve his problem
any visitor of the site
can overlook the list of all questions
} do

  given!(:questions) { create_list(:question, 5) }

  scenario 'user tries to view list of all questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end