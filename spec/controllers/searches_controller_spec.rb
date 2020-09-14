require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  describe 'GET#Search' do
    let(:user) { create(:user, email: 'test@user.com') }
    let(:question) { create(:question, user: user, title: 'test question') }
    let!(:answer) { create(:answer, user: user, question: question, body: 'test answer') }
    let!(:search_result) { double 'search_result' }
    let!(:paginated_result) { double 'paginated_result'}
    let(:params) { {} }
    before do
      question.comments.create(user: user, body: 'test comment for question')
      answer.comments.create(user: user, body: 'test comment for answer')
    end

    it 'populates array with search result' do
      ThinkingSphinx::Test.run do
        get :search, params: {query: 'test'}
        expect(assigns(:results)).to eq ThinkingSphinx.search('test')
      end
    end

    it 'run search on ThinkingSphinx class if exact class was not specified' do
      allow(ThinkingSphinx).to receive(:search).with(ThinkingSphinx::Query.escape 'test').and_return(search_result)
      allow(search_result).to receive(:page).with(params[:page]).and_return(paginated_result)
      allow(paginated_result).to receive(:per).with(10).and_return(double 'results')
      expect(ThinkingSphinx).to receive(:search).with(ThinkingSphinx::Query.escape 'test')
      get :search, params: { query: 'test' }
    end

    it 'run search on Question class when specified' do
      allow(Question).to receive(:search).with(ThinkingSphinx::Query.escape 'test').and_return(search_result)
      allow(search_result).to receive(:page).with(params[:page]).and_return(paginated_result)
      allow(paginated_result).to receive(:per).with(10).and_return(double 'results')
      expect(Question).to receive(:search).with(ThinkingSphinx::Query.escape 'test')
      get :search, params: { query: 'test', query_class: 'Question'}
    end
  end
end