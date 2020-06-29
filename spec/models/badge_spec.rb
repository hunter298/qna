require 'rails_helper'

RSpec.describe Badge, type: :model do
  it { should belong_to :question }
  it { should have_many(:users).through(:achievements) }

  it { should validate_presence_of :name }
end
