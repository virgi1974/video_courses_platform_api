require 'rails_helper'

RSpec.describe Course, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_uniqueness_of(:title) }
  end

  context 'db configuration' do
    it { should have_db_index(:title).unique(true) }
  end

  context 'associations' do
    it { is_expected.to have_many(:registrations) }
    it { is_expected.to have_many(:users) }
  end
end
