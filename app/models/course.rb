class Course < ApplicationRecord
  include Like

  has_many :registrations
  has_many :users, through: :registrations

  validates_uniqueness_of :title, :case_sensitive => true
  validates_presence_of :title

  acts_as_votable
end
