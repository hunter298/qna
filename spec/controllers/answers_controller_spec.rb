require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'GET #new' do
    before { get :new, params: {question_id: create(:question)} }

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'save new answer to database' do
        expect { post :create, params: {question_id: create(:question), answer: attributes_for(:answer)} }.to change(Answer, :count).by(1)
      end

      it 'redirect to question' do
        post :create, params: {question_id: create(:question), answer: attributes_for(:answer)}

        expect(response).to redirect_to (assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save answer to database' do
        expect { post :create, params: { question_id: create(:question), answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
      end

      it 'renders new view' do
        post :create, params: { question_id: create(:question), answer: attributes_for(:answer, :invalid) }

        expect(response).to render_template(:new)
      end
    end
  end

end
