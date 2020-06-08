require 'rails_helper'

feature 'user can create answer', %q{
in order to help to find solution for other user's question
registered user
should be able to create answer
} do

  describe 'authorized user' do
    scenario 'tries to add answer' do

    end

    scenario 'tries to delete own answer' do

    end

    scenario "tries to delete another's answer" do

    end
  end

  describe 'unauthorized user' do
    scenario 'tries to add answer' do

    end

    scenario 'tries to delete own answer' do

    end

    scenario "tries to delete another's answer" do

    end
  end
end