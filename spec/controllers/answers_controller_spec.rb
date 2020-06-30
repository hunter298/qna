require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:user) { create(:user) }
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
          expect { delete :destroy, params: {id: answer}, format: :js }.to change(Answer, :count).by(-1)
        end

        it 'redirects to question page' do
          delete :destroy, params: {id: answer}, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'not an author of answer' do
        let!(:other_answer) { create(:answer, question: question, user: create(:user)) }

        it 'does not erase answer from database' do
          expect { delete :destroy, params: {id: other_answer}, format: :js }.to_not change(Answer, :count)
        end

        it 'redirects to question page' do
          delete :destroy, params: {id: answer}, format: :js
          expect(response).to render_template :destroy
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

    describe 'author of answer' do
      context 'tries to edit answer with valid attributes' do
        before do
          sign_in(user)
          patch :update, params: {id: answer, answer: {body: 'new body'}}, format: :js
        end

        it 'changes answer attributes' do
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'renders update view' do
          expect(response).to render_template :update
        end
      end

      context 'tries to edit answer with invalid attributes' do
        it 'does not change answer attributes' do
          sign_in(user)

          expect do
            patch :update, params: {id: answer, answer: attributes_for(:answer, :invalid)}, format: :js
          end.to_not change(answer, :body)
        end

        it 'renders update view' do
          sign_in(user)
          patch :update, params: {id: answer, answer: attributes_for(:answer, :invalid)}, format: :js

          expect(response).to render_template :update
        end
      end
    end

    describe 'not an author of answer' do
      scenario 'tries to edit answer' do
        sign_in(create(:user))

        patch :update, params: {id: answer, answer: {body: 'new body'}}, format: :js
        answer.reload

        expect(answer.body).to_not eq 'new body'
      end
    end
  end

  describe 'POST #Best' do
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:other_user) { create(:user) }
    let!(:other_answer) { create(:answer, question: question, user: other_user, best: true) }
    let!(:third_answer) { create(:answer, question: question, user: other_user) }
    let!(:badge) { Badge.create(name: 'test', question: question) }

    context 'author of question tries to flag answer as best one' do
      it 'should change best attribute of answer to true', js: true do
        sign_in(user)

        post :best, params: {id: answer}, format: :js

        expect(answer.reload).to be_best
      end

      it 'should change best attribute of other answer to false' do
        sign_in(user)

        post :best, params: {id: answer}, format: :js

        expect(other_answer.reload.best).to eq false
      end

      it 'should give question badge to answer author' do
        sign_in(user)

        post :best, params: {id: third_answer}, format: :js

        expect(other_user.badges).to include badge
      end
    end

    context 'not author of question tries to flag answer as best one' do
      it 'should not change best attribute of answer' do
        sign_in(other_user)

        post :best, params: {id: answer}, format: :js

        expect(answer.best).to eq false
      end
    end
  end

  describe 'DELETE #Delete_file_attached' do
    let!(:answer) { create(:answer, question: question, user: user) }

    before do
      answer.files.attach(io: File.new("#{Rails.root}/tmp/test-file.txt", "w+"), filename: 'test-file.txt')
    end

    context 'author of answer tries to delete attached file' do
      before do
        sign_in(user)

        delete :delete_file_attached, params: {id: answer.files.last.id}, format: :js
      end

      it 'should purge attached file' do
        expect(answer.files.reload).to be_empty
      end

      it 'should render delete_file_attached view' do
        expect(response).to render_template 'shared/_delete_file_attached'
      end
    end

    context 'other user tries to delete attached file' do
      before do
        sign_in(create(:user))

        delete :delete_file_attached, params: {id: answer.files.last.id}, format: :js
      end

      it 'should not purge file' do
        expect(answer.files.reload).to_not be_empty
      end
    end
  end

end
