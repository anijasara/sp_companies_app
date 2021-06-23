class Company < ApplicationRecord
  belongs_to :parent_company, class_name: "Company", foreign_key: "parent_id", optional: true
  has_many :sub_companies, class_name: "Company", foreign_key: "parent_id" , dependent: :destroy
  has_many :employees, dependent: :destroy

  # has_many :parent_companies, class_name: "Company", foreign_key: "parent_id"

  validates_uniqueness_of :cid
  validates_uniqueness_of :name, scope: :cid
  validates_presence_of :name, :cid

  scope :all_parent_companies, -> { where(parent_id: nil) }

  def self.delete_employees(employee_ids)
    true if employee_ids.map {|id| Employee.delete(id)}
  end

  def self.companies_less_than_target_employees
    self.all_parent_companies.select{|company| company.total_employees < company.reqd_no_of_employees}
  end

  def sub_sub_companies
    sub_companies.flat_map(&:sub_companies).uniq
  end

  def total_employees(employee_count = 0)
    employee_count = employee_count + self.employees.try(:count)
    if(self.sub_companies.present?)
      # get all employee_counts for sub-companies and sub-sub-companies
      employee_count = emp_count_of_sub_companies(self, employee_count)
    end
    employee_count
  end

  def emp_count_of_sub_companies(company, employee_count)
    company.sub_companies.each do |company|
      comp_emp_count = company.employees.try(:count)
      employee_count = employee_count + comp_emp_count
      # call the recursive method if sub companies present for each of the iterating company
      employee_count = emp_count_of_sub_companies(company, employee_count) if company.sub_companies.present?
    end
    employee_count
  end

  # def parent_companies(result = [])
  #   result.push([self])
  #   if(!self.sub_companies.empty?)
  #     self.sub_companies.each do |company|
  #       result = company.parent_companies(result)
  #     end
  #   end
  #   result
  # end
end
