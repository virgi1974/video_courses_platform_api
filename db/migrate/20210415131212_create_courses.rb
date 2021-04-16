# frozen_string_literal: true

class CreateCourses < ActiveRecord::Migration[6.1]
  def change
    create_table :courses do |t|
      t.string :title

      t.timestamps
    end
    add_index :courses, :title, unique: true
  end
end
