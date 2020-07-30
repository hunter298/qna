require 'rails_helper'

RSpec.describe ActiveStorage::AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }

    before do
      question.files.attach(io: File.new("#{Rails.root}/tmp/test-file.txt", "w+"), filename: 'test-file.txt')
      answer.files.attach(io: File.new("#{Rails.root}/tmp/test-file.txt", "w+"), filename: 'test-file.txt')
    end

    context 'author of question tries to delete attached file' do
      before do
        sign_in(user)

        delete :destroy, params: {id: question.files.first.id}, format: :js
      end

      it 'should purge attached file' do
        expect(question.files.reload).to be_empty
      end

      it 'should render delete_file_attached view' do
        expect(response).to render_template :destroy
      end
    end

    context 'author of answer tries to delete attached file' do
      before do
        sign_in(user)

        delete :destroy, params: {id: answer.files.first.id}, format: :js
      end

      it 'should purge attached file' do
        expect(answer.files.reload).to be_empty
      end

      it 'should render delete_file_attached view' do
        expect(answer).to render_template :destroy
      end
    end

    context 'other user tries to delete attached to question file' do
      before do
        sign_in(create(:user))

        delete :destroy, params: {id: question.files.first.id}, format: :js
      end

      it 'should not purge file' do
        expect(question.files.reload).to_not be_empty
      end
    end

    context 'other user tries to delete attached to answer file' do
      before do
        sign_in(create(:user))

        delete :destroy, params: {id: answer.files.first.id}, format: :js
      end

      it 'should not purge file' do
        expect(answer.files.reload).to_not be_empty
      end
    end
  end
end