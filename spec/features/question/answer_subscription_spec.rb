require 'rails_helper'

feature 'user can subscribe for new answer', %q{
in order to receive new answers for concerning question
as an authorized user
I want to be able to subscribe for email distribution
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }

  context 'authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries to subscribe for new answers', js: true do
      click_on 'Subscribe'

      expect(page).to have_content('Unsubscribe')
      expect(Subscription.count).to eq 1
    end

    scenario 'tries to unsubscribe from answer', js: true do
      click_on 'Subscribe'
      click_on 'Unsubscribe'

      expect(Subscription.count).to eq 0
    end
  end

  context 'unauthenticated user' do
    background do
      visit question_path(question)
    end

    scenario 'tries to subscribe for new answers' do
      expect(page).to_not have_content('Subscribe')
    end
  end
end