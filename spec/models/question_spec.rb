require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to :user }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:badge).dependent(:destroy) }

  it { should accept_nested_attributes_for :links }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it 'has many attached file' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe "Question#upvote" do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }

    it 'increases question rating by 1' do
      expect { question.upvote }.to change(question, :rating).by(1)
    end
  end

end
