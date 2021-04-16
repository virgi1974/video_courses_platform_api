# frozen_string_literal: true

p '######## CREATING USERS ########'
5.times do
  FactoryBot.create(:user)
end

p '######## CREATING COURSES ########'
5.times do
  FactoryBot.create(:course)
end

p '######## CREATING REGISTRATIONS ########'
User.all.each do |user|
  courses = Course.all.shuffle
  FactoryBot.create(:registration, user: user, course: courses[0])
  FactoryBot.create(:registration, user: user, course: courses[1])
  FactoryBot.create(:registration, user: user, course: courses[2])
end
