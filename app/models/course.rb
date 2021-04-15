class Course < ApplicationRecord
  validates_uniqueness_of :title, :case_sensitive => true
  validates_presence_of :title
end
