require 'rails_helper'

RSpec.describe DailyDigestService do
  let(:users) { create_list(:user, 3) }

  it 'sends daily digest to all users' do
    User.find_each do |user|
      expect(DailyDigestMailer).to receive(:digest).with(user)
      subject.send_digest
    end
  end
end