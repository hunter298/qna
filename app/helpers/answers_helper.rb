module AnswersHelper
  def answer_path(answer)
    "/questions/#{answer.question_id}#answer-#{answer.id}"
  end
end
