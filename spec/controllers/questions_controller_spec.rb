require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  let(:user) { create(:user) }
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
  end

  describe 'GET #show' do
    before { get :show, params: {id: question} }

    it 'renders show view' do
      expect(response).to render_template :show
    end

    it 'assigns new answer to question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns new link to answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new }

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves new question in database' do
        expect { post :create, params: {question: attributes_for(:question)} }.to change(Question, :count).by(1)
      end
      it 'redirects to show view' do
        post :create, params: {question: attributes_for(:question)}
        expect(response).to redirect_to(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save question in database' do
        expect { post :create, params: {question: attributes_for(:question, :invalid)} }.to_not change(Question, :count)
      end

      it 're-render new view' do
        post :create, params: {question: attributes_for(:question, :invalid)}
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: {id: question, question: attributes_for(:question)}, format: :js
        expect(assigns(:question)).to eq question
      end

      it 'cahnges question attributes' do
        patch :update, params: {id: question, question: {body: 'new body', title: 'new title'}}, format: :js
        question.reload

        expect(question.body).to eq 'new body'
        expect(question.title).to eq 'new title'
      end

      it 'renders template update' do
        patch :update, params: {id: question, question: attributes_for(:question)}, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change question' do
        question.reload

        expect do
          patch :update, params: {id: question, question: attributes_for(:question, :invalid)}, format: :js
        end.to_not change(question, :title)

        expect do
          patch :update, params: {id: question, question: attributes_for(:question, :invalid)}, format: :js
        end.to_not change(question, :body)
      end


      it 'render update view' do
        patch :update, params: {id: question, question: attributes_for(:question, :invalid)}, format: :js
        expect(response).to render_template :update
      end
    end
  end


  describe 'DELETE #destroy' do
    context 'authorized user' do
      context 'user is author' do
        before { login(user) }

        let!(:question) { create(:question, user: user) }

        it 'can delete the question' do
          expect { delete :destroy, params: {id: question}, format: :js }.to change(Question, :count).by(-1)
        end

        it 'redirects to index' do
          delete :destroy, params: {id: question}, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'user is not author' do
        before { login(user) }
        let!(:other_user) { create(:user) }
        let!(:question) { create(:question, user: other_user) }
        it 'can not delete the question' do
          expect { delete :destroy, params: {id: question}, format: :js }.to_not change(Question, :count)
        end

        it 'shows error message' do
          delete :destroy, params: {id: question}, format: :js
          expect(response.status).to eq 403
        end
      end
    end

    context 'unauthorized user' do
      let!(:question) { create(:question, user: user) }
      it 'can not delete question' do
        expect { delete :destroy, params: {id: question} }.to_not change(Question, :count)
      end
    end
  end

  describe 'PATCH #Upvote' do
    let(:some_user) { create(:user) }
    let!(:own_question) { create(:question, user: some_user) }
    let!(:other_question) { create(:question, user: create(:user)) }

    it_behaves_like 'Upvotable' do
      let(:user) { :some_user }
      let(:foreign_object) { :other_question }
      let(:own_object) { :own_question }
    end
  end

  describe 'PATCH #Downvote' do
    let(:some_user) { create(:user) }
    let!(:own_question) { create(:question, user: some_user) }
    let!(:other_question) { create(:question, user: create(:user)) }

    it_behaves_like 'Downvotable' do
      let(:user) { :some_user }
      let(:other_object) { :other_question }
      let(:own_object) { :own_question }
    end
  end


end
