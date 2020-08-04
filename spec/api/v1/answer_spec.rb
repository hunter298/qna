require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { {"ACCEPT" => 'application/json'} }
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET /api/v1/questions/:question_id/answers' do
    let!(:answers) { create_list(:answer, 3, question: question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let!(:answer) { answers.first }

      before { get api_path, params: {access_token: access_token.token}, headers: headers }

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 3
      end

      it 'return all public fields of answer' do
        %w[id body user_id question_id created_at updated_at].each do |attr|
          expect(json['answers'].first[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:links) { create_list(:link, 3, linkable: answer) }
    let!(:comments) { create_list(:comment, 3, commentable: answer, user: user) }
    let(:api_path) { "/api/v1//answers/#{answer.id}" }

    before do
      answer.files.attach(io: File.new("#{Rails.root}/tmp/test-file1.txt", "w+"), filename: 'test-file1.txt')
      answer.files.attach(io: File.new("#{Rails.root}/tmp/test-file2.txt", "w+"), filename: 'test-file2.txt')
    end

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      before { get api_path, params: {access_token: access_token.token}, headers: headers }

      it 'should return 200 status' do
        expect(response).to be_successful
      end

      it 'should return answer' do
        expect(json).to have_key 'answer'
      end

      it 'return all public fields of answer' do
        %w[id body user_id question_id created_at updated_at].each do |attr|
          expect(json['answer'][attr]).to eq answer.send(attr).as_json
        end
      end

      it 'return list of comments to answer' do
        expect(json['answer']['comments'].length).to eq 3
      end

      it 'return list of links to answer' do
        expect(json['answer']['links'].length).to eq 3
      end

      it 'return list of attached files URL' do
        expect(json['answer']['files'].length).to eq 2
      end
    end
  end

  describe 'POST /api/v1/questions/:question_id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API authorizable' do
      let(:method) { :post }
    end

    it_behaves_like 'API creatable' do
      let(:creatable) { :answer }
    end
  end

  describe "DELETE /api/v1/answers/:id" do
    let!(:answer) { create(:answer, user: user, question: question) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      it_behaves_like 'API deletable' do
        let(:deletable) { :answer }
      end
    end

    context 'admin' do
      let(:admin) { create(:user, admin: true) }
      let!(:other_answer) { create(:answer, question: question, user: create(:user)) }
      let(:admin_token) { create(:access_token, resource_owner_id: admin.id) }

      it 'should be able to delete other user question' do
        expect {
          delete "/api/v1/answers/#{other_answer.id}", params: {access_token: admin_token.token}, headers: headers
        }.to change(Answer, :count).by(-1)
      end
    end
  end

  describe 'GET /api/v1/answers/:id/edit' do
    let!(:answer) { create(:answer, question: question, user: user) }
    let(:api_path) { "/api/v1/answers/#{answer.id}/edit" }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    it_behaves_like 'API editable' do
      let(:editable) { :answer }
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let!(:answer) { create(:answer, question: question, user: user) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API authorizable' do
      let(:method) { :patch }
    end

    it_behaves_like 'API updatable' do
      let(:updatable) { :answer }
    end
  end
end