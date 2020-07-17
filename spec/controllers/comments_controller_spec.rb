require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe "POST#Add_comment" do
    context 'authenticated user' do
      before { login(user) }
      it 'should create new comment in db' do
        expect do
          post :create, params: {question_id: question, comment: attributes_for(:comment) }, format: :json
        end.to change(Comment, :count).by(1)
      end

      it 'should not create new db entry, when invalid data passed' do
        expect do
          post :create, params: { question_id: question, comment: {body: ''} }, format: :json
        end.to_not change(Comment, :count)
      end
    end

    context 'unauthenticated user' do
      it "doesn't save new comment" do
        expect do
          post :create, params: {question_id: question, comment: {body: 'Some text'}}, format: :json
        end.to_not change(Comment, :count)
      end
    end
  end

end