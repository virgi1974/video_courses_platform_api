# frozen_string_literal: true

class Registration < ApplicationRecord
  class AlreadyCreatedError < StandardError; end

  class CreationError < StandardError; end
  belongs_to :user
  belongs_to :course
end
