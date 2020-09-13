# require 'sphinx_helper'
#
# feature 'user can search for entries', %q{
# in order to find interesting entries by keyword
# as an visitor of site
# I want to be able to use full-text search
# # } do
#   # given(:user) { create(:user) }
#   # given!(:question) { create(:question, user: user, title: 'Keyword') }
#
#   # scenario 'user searches for question', sphinx: true do
#   #   visit root_path
#   #
#   #   ThinkingSphinx::Test.run do
#   #     fill_in 'query', with: 'Keyword'
#   #     click_button 'Search'
#   #     expect(page).to have_content question.title
#   #   end
#   # end
# end