require 'rails_helper'

RSpec.describe NewAnswerNoticeService do
  let(:users) { create_list(:user, 3) }
  let(:question) { create(:question, user: users[0]) }
  let!(:answer) { create(:answer, user: users[0], question: question, body: 'random text') }

  before do
    users.each { |user| user.subscriptions.create(question: question) }
  end

  it 'sends notice about new answer to every subscribed user' do
    users.each do |user|
      expect(NewAnswerNoticeMailer).to receive(:notice).with(user, answer).and_call_original
    end
    subject.send_notice(answer)
  end
end
