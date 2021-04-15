FactoryBot.define do
  factory :registration do
    user { FactoryBot.create(:user) }
    course { FactoryBot.create(:course) }
  end
end
