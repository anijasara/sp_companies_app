class Employee < ApplicationRecord
  belongs_to :company

  validates_uniqueness_of :emp_id
  validates_presence_of :name, :emp_id
end
