require 'rails_helper'

RSpec.describe NewAnswerNoticeService do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, user: create(:user), question: question, body: 'random text') }

  it 'send notice about new answer for question to author' do
    expect(NewAnswerNoticeMailer).to receive(:notice).with(user, answer).and_call_original
    subject.send_notice(answer)
  end
end