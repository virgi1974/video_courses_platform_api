# 📹 video_courses_platform_api

API to let teachers to apply for courser to teach, and for all sort of users to vote the different teachers and courses.  
The idea is to have a simple interface.

- **GET /registrations** [endpoint to retrieve the history of registrations stored in DB]
- **POST /registrations** [endpoint to create a new registrations]
- **PUT /like** [endpoints to like against users or courses)]

### Dependencies

To ease the Mysql DB setup I chose a full Dockerized app version instead of a local setup, with these dependencies

- Ruby version. 3.0.1 (latest)
- Rails version. 6.1.3.1 (latest)
- Database Mysql 5.7

Rails project has been setup in API only mode, removing unneeded frameworks such as ActionCable or default Test folders.  
The only required software to run the app are 🐳 `Docker`&`docker-compose`.

### Installation

We need first to clone the repo and then follow the steps to get the full app and DB running in containers.

1. Install Docker & Docker-compose
2. Run `docker-compose build`. This will start two containers where the DB and the app will be running.  
   It is gonna take some time the first time since it has to download images for both Ruby and Mysql, and install all the dependencies.
3. We can then run a shell in the app container  
   `docker exec -it 180945e859a7 sh`  
   and once inside trigger the db Rails setup commands  
   `rails db:create db:migrate db:seed`
   **OR BETTER** execute directly via the command line with  
   `docker-compose run --rm app bundle exec rails db:create db:migrate db:seed`
4. Now the app can be run with `docker-compose up`. This will start two containers where the DB and the app will be running.
5. From this point we'll be using the commands `docker-compose down` (or just `CTRL+C`) and `docker-compose up`  
   to stop/start the app.  
   We should be able to access the app via the port `3000`.  
   In case some error due to some old Rails pid process not being properly deleted we'll have to delete in the `tmp/server.pid` file.
6. Once it is finished we have to get the container id related to the image we are using with something like  
   `docker ps | grep video_courses_platform_api_app`

NOTE  
Every time we add dependencies to the project we need to build images again `docker-compose up --build` to bundle install the related dependency.

TIP  
To properly debug using `pry` or similar we'll have to attach to the running container with `docker attach video_courses_platform_api_app_1`

### Data

Basic data to populate database can be found in the file `seeds.rb`.

### DB Modelling

**Registration** - holds the relation between users and courses when users apply for a course  
**User** - just with an `email` uniq field  
**Course** - just with an `title` uniq field

### Usage

The different endpoints can be tested via Postman or any other Http client.

In the `routes.rb` file the different routes of the project can be seen in detail.  
All resources have been placed under the same namespace, not assuming nested relationships among then as this was not clearly stated.  
Api versioning has been used from the beginning, so all routes should use prefix `/api/v1`  
There are 4 endpoints

        GET /api/v1/registrations    To get all registrations (registrations history)
        POST /api/v1/registrations   To create a registration
        PUT /api/v1/:user_id/like    To like a user
        PUT /api/v1/:course_id/like  To like a course

The chosen json structure response for the registrations history **GET /registrations** is this

```
{
  "total_registrations": 20,
  "page": 2,
  "results_per_page": 5,
  "registrations": [
    {
      "user": {
        "id": 2,
        "email": "bryon@dibbert-morar.net",
        "likes": 3
      },
      "course": {
          "id": 2,
          "title": "Yukihiro Matsumoto R++",
          "likes": 0
      },
      "created_at": "04/16/2021 - 05:04PM"
    },
    ...
```

The json structure response for the **POST /registration** is this

```
{
  "user_id": 5,
  "user_email": "robbyn.tromp@effertz.biz",
  "course_title": "Title",
  "created_at": "04/16/2021 - 07:15PM"
}
```

We added a generic response for cases where registration creation fails

```
{
  "error_message": "you already have applied for that course"
}
```

For the like actions the response is an empty 200 when sending data such as

```
{
	"voter_id": 1
}
```

### Testing ⛑️

The test suite can be run by using the command **`docker-compose run --rm app bundle exec rspec`** on the `app` service container.  
Gem Simplecov was added to ensure full coverage.  
![](https://user-images.githubusercontent.com/13310108/115074853-88db0600-9efa-11eb-8844-d03c6fee6b53.png)

A Postman collection to test the existinf endpoints can be found in the file **Dmka.postman_collection.json**

### Linters

Rubocop has been used to keep consistency in the code base.  
It can be run with `docker-compose run --rm app bundle exec rubocop`

#### Some details about the workflow and decissions made

- It seemed like no authentication/authorization was required in this stage, so I choose a very basic implementation for users to consume the API. The current user doing the request is present in the json as `user_id` or `voter_id`. This is far from ideal but it was quicker. A much better way would have been the use of Tokens to authorize users for API actions, being detected in a before filter. That way we could have had a `current_user` perfectly visible.
- The User model could have had different roles such as `user/teacher/admin` but the required actions seemed not to need it.
- The data modeling was not clear at this stage, so I didn't nest any of the resources, though several relationships among the could have been implemented.

#### How would you improve your solution? What would be the next steps? 💡

- Adding swagger as a self explanatory documenation
- Authentication/Authorization.
- the GEM acts_as_votable which has been used for the voting functionality has pretty interesting options to improve performance via adding extra indexation; worth to keep in mind.
