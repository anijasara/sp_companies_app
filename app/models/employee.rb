class Employee < ApplicationRecord
  belongs_to :company

  validates_uniqueness_of :emp_id
  validates_presence_of :name, :emp_id

  scope :company_employees, -> (comp_id) { where(company_id: comp_id) }
end
