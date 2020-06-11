require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  let(:user) { create(:user)}
  let(:question) { create(:question, user: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, user: user) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end

    describe 'GET #show' do
      before { get :show, params: { id: question } }

      it 'renders show view' do
        expect(response).to render_template :show
      end
    end

    describe 'GET #new' do
      before { login(user) }

      before { get :new }

      it 'render new view' do
        expect(response).to render_template :new
      end
    end

    describe 'GET #edit' do
      before { login(user) }
      before { get :edit, params: { id: question } }

      it 'renders edit view' do
        expect(response).to render_template :edit
      end
    end

    describe 'POST #create' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves new question in database' do
          expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
        end
        it 'redirects to show view' do
          post :create, params: { question: attributes_for(:question) }
          expect(response).to redirect_to(assigns(:question))
        end
      end

      context 'with invalid attributes' do
        it 'does not save question in database' do
          expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
        end

        it 're-render new view' do
          post :create, params: { question: attributes_for(:question, :invalid) }
          expect(response).to render_template :new
        end
      end
    end

    describe 'PATCH #update' do
      before { login(user) }

      context 'with valid attributes' do
        it 'assigns the requested question to @question' do
          patch :update, params: { id: question, question: attributes_for(:question) }
          expect(assigns(:question)).to eq question
        end

        it 'cahnges question attributes' do
          patch :update, params: { id: question, question: { body: 'new body', title: 'new title' } }
          question.reload

          expect(question.body).to eq 'new body'
          expect(question.title).to eq 'new title'
        end

        it 'redirects to updated question' do
          patch :update, params: { id: question, question: attributes_for(:question) }
          expect(response).to redirect_to question
        end
      end

      context 'with invalid attributes' do
        before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) } }
        it 'does not change question' do
          question.reload

          expect(question.title).to eq question.title
          expect(question.body).to eq question.body
        end

        it 're-render edit view' do
          expect(response).to render_template(:edit)
        end
      end
    end

    describe 'DELETE #destroy' do
      before { login(user) }

      let!(:question) { create(:question, user: user) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end
  end

end
