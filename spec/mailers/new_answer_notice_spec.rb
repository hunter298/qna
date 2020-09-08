require "rails_helper"

RSpec.describe NewAnswerNoticeMailer, type: :mailer do
  describe "notice" do
    let(:mail) { NewAnswerNoticeMailer.notice }

    it "renders the headers" do
      expect(mail.subject).to eq("Notice")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
