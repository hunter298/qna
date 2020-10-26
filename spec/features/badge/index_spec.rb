require 'rails_helper'

feature 'user can view list of earned badges', "
in order to be more motivated to answer questions
as a user of site
I'd like to be able to overview my badges
" do
  given(:user) { create(:user) }
  given(:questions) { create_list(:question, 3, user: user) }
  given!(:badges) do
    user.badges.push(Badge.create([{ name: 'first', question: questions[0] },
                                   { name: 'second', question: questions[1] },
                                   { name: 'third', question: questions[2] }]))
  end

  scenario 'user tries to overview his badges' do
    sign_in(user)
    visit badges_path

    user.badges.each do |badge|
      expect(page).to have_content badge.name
    end
  end
end
