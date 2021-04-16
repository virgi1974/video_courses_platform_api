class User < ApplicationRecord
  has_many :registrations
  has_many :courses, through: :registrations

  validates_uniqueness_of :email, :case_sensitive => true

  validates :email,
             format: { with: URI::MailTo::EMAIL_REGEXP },
             presence: true
end