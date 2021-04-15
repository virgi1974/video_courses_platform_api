require 'rails_helper'

RSpec.describe Registration, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:course) }
  end
end
