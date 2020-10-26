require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  describe 'Link#is_gist?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:link) do
      create(:link,
             linkable: question,
             name: 'gist',
             url: 'https://gist.github.com/hunter298/0b36c45df3e2a79aed5a178e6cca01ac')
    end
    let!(:other_link) { create(:link, linkable: question) }

    it 'should return true if link is gist' do
      expect(link.gist?).to be_truthy
    end

    it "should return false if link isn't gist" do
      expect(other_link.gist?).to be_falsey
    end
  end

  describe 'Link#gist' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:link) do
      create(:link,
             linkable: question,
             name: 'gist',
             url: 'https://gist.github.com/hunter298/0b36c45df3e2a79aed5a178e6cca01ac')
    end

    it 'should return gist content' do
      expect(link.gist).to eq 'test gist'
    end
  end
end
