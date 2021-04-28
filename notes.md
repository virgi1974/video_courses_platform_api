# RUNNING THE APP
```
docker-compose build

docker-compose up

docker-compose up --build

docker-compose down  
```

# DB
```
docker-compose run app --rm app rails db:create db:migrate db:seed

docker-compose run --rm app bundle exec rails db:rollback

bundle exec rails g model Registration user:references user:references  
```

# GENERATORS
```
docker-compose run --rm app bundle exec rails generate model User email

docker-compose -rm run app rails g resource post

docker-compose run --rm app bundle exec rails generate scaffold Post name:string title:string content:text slug:string:uniq

docker-compose run --rm app bundle exec rails destroy scaffold Post name:string title:string content:text slug:string:uniq  
```

# OTHER FLAVOURS
```
docker-compose run --rm app bundle exec rails c

docker attach video_courses_platform_api_app_1

docker-compose run --rm app bundle exec rspec

docker-compose run --rm web bundle exec rubocop

docker-compose run --rm app bundle exec rubocop --auto-correct-all  
```

============== ACTS AS VOTABLE ================
```
@course.downvote_from @user
@course.vote_by :voter => @user

@course.votes_for.size # => 5

course.liked_by user
course.downvote_from user
course.get_likes.size # => 3
course.get_upvotes.size # => 3

course.liked_by user
course.get_likes
``