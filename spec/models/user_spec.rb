# frozen_string_literal: true
require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { should allow_value("email@addresse.foo").for(:email) }
    it { should_not allow_value("foo").for(:email) }
  end

  context 'db configuration' do
    it { should have_db_index(:email).unique(true) }
  end

  context 'associations' do
    it { is_expected.to have_many(:registrations) }
    it { is_expected.to have_many(:courses) }
  end
end