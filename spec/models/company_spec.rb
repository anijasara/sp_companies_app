require 'rails_helper'

RSpec.describe Company, type: :model do
  let(:company) {
    FactoryBot.create(:company)
  }

  describe '#associations' do
    it { should have_many(:employees).dependent(:destroy) }
  end

  describe '#validations' do
    it "should validates uniqueness of company_id" do
      should validate_uniqueness_of(:cid)
    end

    it "should validates presence of name" do
      should validate_presence_of(:name)
    end
  end

  describe '#class_methods' do
    it "should delete the employees by passing emp_ids" do
      employee = FactoryBot.create(:employee, name: 'Test emp',company_id: company.id, emp_id: 'E01')
      expect(Company.delete_employees([employee.id.to_s])).to eq(true)
      expect(Employee.all).to be_empty
    end

    it "should get the total employees of company and its sub-companies" do
      employee = FactoryBot.create(:employee, name: 'Test emp',company_id: company.id, emp_id: 'E01')
      employee = FactoryBot.create(:employee, name: 'Test emp2',company_id: company.id, emp_id: 'E02')
      expect(company.total_employees).to eq(2)
    end

    it "should get the companies where required no of employees less than target" do
      employee = FactoryBot.create(:employee, name: 'Test emp',company_id: company.id, emp_id: 'E01')
      employee = FactoryBot.create(:employee, name: 'Test emp2',company_id: company.id, emp_id: 'E02')
      company.update(reqd_no_of_employees: 10, parent_id: nil)
      expect(Company.companies_less_than_target_employees.count).to eq(1)
    end
  end
end
