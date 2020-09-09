require 'rails_helper'

RSpec.describe NewAnswerNoticeJob, type: :job do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:service) { double 'NewAnswerNoticeService' }

  before do
    allow(NewAnswerNoticeService).to receive(:new).and_return(service)
  end

  it 'calls NewAnswerNoticeService#send_notice' do
    expect(service).to receive(:send_notice).with(answer)
    NewAnswerNoticeJob.perform_now(answer)
  end
end
