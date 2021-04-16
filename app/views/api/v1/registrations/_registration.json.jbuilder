json.user do
  json.id registration.user.id
  json.email registration.user.email
  json.likes 20
end

json.course do
  json.id registration.course.id
  json.title registration.course.title
  json.likes 30
end

json.created_at registration.created_at.strftime('%m/%d/%Y - %I:%M%p')
