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

  context 'methods' do
    describe '#likes' do
      it 'has value 0 as default' do
        course = create(:course)
        expect(course.likes).to eq(0)
      end
      
      it 'has value equal to the number of times it was liked' do
        course = create(:course)

        number_of_likes = rand(1..5)
        number_of_likes.times do
          user = create(:user)
          course.liked_by(user)
        end
        expect(course.likes).to eq(number_of_likes)
      end
    end
  end
end
