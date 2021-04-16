json.user_id      @registration.user.id
json.user_email   @registration.user.email
json.course_title @registration.course.title
json.created_at   @registration.created_at.strftime('%m/%d/%Y - %I:%M%p')

