require 'rails_helper'

RSpec.describe Employee, type: :model do
  let(:employee) {
    FactoryBot.create(:employee)
  }

  describe '#associations' do
    it { should belong_to(:company) }
  end

  describe '#validations' do
    it "should validates uniqueness of employee_id" do
      should validate_uniqueness_of(:emp_id)
    end

    it "should validates presence of name" do
      should validate_presence_of(:name)
    end
  end
end