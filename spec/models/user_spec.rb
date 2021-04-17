# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { should allow_value('email@addresse.foo').for(:email) }
    it { should_not allow_value('foo').for(:email) }
    it { is_expected.to validate_presence_of(:role) }
    it { is_expected.to allow_values(:user, :teacher).for(:role) }
  end

  context 'db configuration' do
    it { should have_db_index(:email).unique(true) }
  end

  context 'associations' do
    it { is_expected.to have_many(:registrations) }
    it { is_expected.to have_many(:courses) }
  end

  context 'methods' do
    describe '#likes' do
      it 'has value 0 as default' do
        user = create(:user)
        expect(user.likes).to eq(0)
      end

      it 'has value equal to the number of times it was liked' do
        liked_user = create(:user)

        number_of_likes = rand(1..5)
        number_of_likes.times do
          voter = create(:user)
          liked_user.liked_by(voter)
        end
        expect(liked_user.likes).to eq(number_of_likes)
      end
    end
  end
end
