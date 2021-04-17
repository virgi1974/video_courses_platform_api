# frozen_string_literal: true

class RegistrationRequest
  attr_reader :user_id, :title

  def initialize(registration_params)
    @user_id = registration_params['user_id']
    @title = registration_params['title']
  end

  def call
    user = User.find(user_id)
    raise_not_allowed_error unless user.teacher?

    course = Course.find_or_create_by!(title: title)

    existing_registration = Registration.find_by(user_id: user.id, course_id: course.id)
    raise_already_created_error if existing_registration

    registration = Registration.new(user: user, course: course)

    registration.save ? RegistrationStruct.new(registration, nil) : raise_creation_error
  rescue StandardError => e
    RegistrationStruct.new(nil, e.message)
  end

  private

  def raise_already_created_error
    raise Registration::AlreadyCreatedError, 'you already have applied for that course'
  end

  def raise_creation_error
    raise Registration::CreationError, 'Error creating a new registration'
  end

  def raise_not_allowed_error
    raise Registration::NotAllowedError, 'you must have the teacher role to perform this action'
  end
end
