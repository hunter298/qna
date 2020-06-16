require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'POST #create' do

    context 'authorized user' do
      before { login(user) }
      context 'with valid attributes' do
        it 'save new answer to database' do
          expect { post :create, params: {question_id: question, answer: attributes_for(:answer)}, format: :js }.to change(Answer, :count).by(1)
        end

        it 'renders create template' do
          post :create, params: {question_id: question, answer: attributes_for(:answer)}, format: :js

          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'does not save answer to database' do
          expect { post :create, params: {question_id: question, answer: attributes_for(:answer, :invalid)}, format: :js }.to_not change(Answer, :count)
        end

        it 'renders create template' do
          post :create, params: {question_id: question, answer: attributes_for(:answer, :invalid)}, format: :js

          expect(response).to render_template :create
        end
      end
    end

    context 'unauthorized user' do

      it 'does not save any answer' do
        expect { post :create, params: {question_id: question, answer: attributes_for(:answer)} }.to_not change(Answer, :count)
      end

      it 'redirects to login page' do
        post :create, params: {question_id: question, answer: attributes_for(:answer)}

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'authorized user' do
      before { login(user) }

      context 'author of answer' do
        it 'erases answer from database' do
          expect { delete :destroy, params: {id: answer} }.to change(Answer, :count).by(-1)
        end

        it 'redirects to question page' do
          delete :destroy, params: {id: answer}
          expect(response).to redirect_to question_path(question)
        end
      end

      context 'not an author of answer' do
        let!(:other_answer) { create(:answer, question: question, user: create(:user)) }

        it 'does not erase answer from database' do
          expect { delete :destroy, params: {id: other_answer} }.to_not change(Answer, :count)
        end

        it 'redirects to question page' do
          delete :destroy, params: {id: answer}
          expect(response).to redirect_to question_path(question)
        end
      end
    end

    context 'unauthorized user' do
      it 'does not erase answer' do
        expect { delete :destroy, params: {id: answer} }.to_not change(Answer, :count)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'with valid attributes' do
      before do
        sign_in(user)
        patch :update, params: { id: answer, answer: { body: 'new body'} }, format: :js
      end

      it 'chages answer attributes' do
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        sign_in(user)

        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end
      it 'renders update view' do
        sign_in(user)
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js

        expect(response).to render_template :update
      end
    end
  end

end
