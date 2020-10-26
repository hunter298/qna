require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2, user: user) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].min_by { |hash| hash['id'] } }
      let!(:answers) { create_list(:answer, 3, question: question, user: user) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response.status).to eq 200
      end

      it 'returns questions list' do
        expect(json['questions'].length).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'returns user id' do
        expect(question_response['user_id']).to eq question.user.id
      end

      it 'contains truncated title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].min_by { |hash| hash['id'] } }

        it 'returns list of answers' do
          expect(question_response['answers'].length).to eq 3
        end

        it 'returns all public fields of answer' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 3, question: question, user: user) }
      let!(:links) { create_list(:link, 3, linkable: question) }
      let!(:comment) { create_list(:comment, 3, commentable: question, user: user) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'return question' do
        expect(json).to have_key 'question'
      end

      it 'returns associated answers, comments and links' do
        %w[answers links comments].each do |association|
          expect(json['question'][association].length).to eq 3
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API authorizable' do
      let(:method) { :post }
    end

    it_behaves_like 'API creatable' do
      let(:creatable) { :question }
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      it_behaves_like 'API deletable' do
        let(:deletable) { :question }
      end
    end

    context 'admin' do
      let(:admin) { create(:user, admin: true) }
      let!(:other_question) { create(:question, user: create(:user)) }
      let(:admin_token) { create(:access_token, resource_owner_id: admin.id) }

      it 'should be able to delete other user question' do
        expect do
          delete "/api/v1/questions/#{other_question.id}", params: { access_token: admin_token.token }, headers: headers
        end.to change(Question, :count).by(-1)
      end
    end
  end

  describe 'GET /api/v1/questions/:id/edit' do
    let(:api_path) { "/api/v1/questions/#{question.id}/edit" }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    it_behaves_like 'API editable' do
      let(:editable) { :question }
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API authorizable' do
      let(:method) { :patch }
    end

    it_behaves_like 'API updatable' do
      let(:updatable) { :question }
    end
  end
end
