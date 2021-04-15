class User < ApplicationRecord
  validates_uniqueness_of :email, :case_sensitive => true

  validates :email,
             format: { with: URI::MailTo::EMAIL_REGEXP },
             presence: true
end
