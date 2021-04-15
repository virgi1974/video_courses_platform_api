class Course < ApplicationRecord
  has_many :registrations
  has_many :users, through: :registrations

  validates_uniqueness_of :title, :case_sensitive => true
  validates_presence_of :title
end
