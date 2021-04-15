FactoryBot.define do
  factory :course do
    title { Faker::ProgrammingLanguage.creator + " " + Faker::ProgrammingLanguage.name }
  end
end
