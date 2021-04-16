class RegistrationRequest
  attr_reader :user_id, :title

  def initialize(registration_params)
    @user_id = registration_params["user_id"]
    @title = registration_params["title"]
  end
  
  def call
    course = Course.find_or_create_by!(title: title)
    user = User.find(user_id)

    existing_registration = Registration.find_by(user_id: user.id, course_id: course.id)
    raise_already_created_error if existing_registration
    
    registration = Registration.new(user: user, course: course)
    
    registration.save ? RegistrationStruct.new(registration, nil) : raise_creation_error
    
  rescue => e
    RegistrationStruct.new(nil, e.message)
  end
  
  private
  
  def raise_already_created_error
    raise Registration::AlreadyCreatedError.new("you already have applied for that course")
  end
  
  def raise_creation_error
    raise Registration::CreationError.new("Error creating a new registration")
  end
end
