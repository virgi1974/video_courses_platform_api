# frozen_string_literal: true

class User < ApplicationRecord
  include Like

  has_many :registrations
  has_many :courses, through: :registrations

  validates_uniqueness_of :email, case_sensitive: true

  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            presence: true

  enum role: %i[user teacher]
  validates :role, presence: true

  acts_as_votable
end
