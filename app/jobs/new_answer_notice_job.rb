class NewAnswerNoticeJob < ApplicationJob
  queue_as :default

  def perform(answer)
    NewAnswerNoticeService.new.send_notice(answer)
  end
end
