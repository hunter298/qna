require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }

  describe 'POST #create' do
    let(:question) { create(:question, user: user) }
    context 'authorized user' do
      before { login(user) }
      context 'with valid attributes' do
        it 'save new answer to database' do
          expect { post :create, params: {question_id: question, answer: attributes_for(:answer)} }.to change(Answer, :count).by(1)
        end

        it 'redirect to question' do
          post :create, params: {question_id: question, answer: attributes_for(:answer)}

          expect(response).to redirect_to (assigns(:question))
        end
      end

      context 'with invalid attributes' do
        it 'does not save answer to database' do
          expect { post :create, params: {question_id: question, answer: attributes_for(:answer, :invalid)} }.to_not change(Answer, :count)
        end

        it 'renders new view' do
          post :create, params: {question_id: question, answer: attributes_for(:answer, :invalid)}

          expect(response).to render_template('questions/show')
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
    let(:question) { create(:question, user: user) }
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

end
