require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { {"CONTENT-TYPE" => "application/json",
                   "ACCEPT" => 'application/json'} }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2, user: me ) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question, user: me )}

      before { get api_path, params: {access_token: access_token.token}, headers: headers }

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

      it 'returns user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains truncated title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

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
end