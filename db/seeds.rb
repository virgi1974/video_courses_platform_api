p '######## CREATING USERS ########'
4.times do
  FactoryBot.create(:user)
end

p '######## CREATING COURSES ########'
5.times do
  FactoryBot.create(:course)
end



