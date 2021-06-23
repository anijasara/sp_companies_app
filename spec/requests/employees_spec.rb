require 'rails_helper'

RSpec.describe "/employees", type: :request do
  let(:company) {
    FactoryBot.create(:company)
  }

  let(:valid_attributes) {
    {
      :emp_id => "E001",
      :name => "Jane Stephen",
      :company_id => company.id
    }
  }

  let(:invalid_attributes) {
    {
      :emp_id => 22, 
      :name => ""
    }
  }

  describe "GET /index" do
    it "renders a successful response" do
      Employee.create! valid_attributes
      get employees_url, as: :json
      expect(response).to be_successful
    end
  end

 describe "GET /show" do
    it "renders a successful response" do
      employee = Employee.create! valid_attributes
      get employee_url(employee), as: :json
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new employee" do
        expect {
          post employees_url, params: valid_attributes , as: :json
        }.to change(Employee, :count).by(1)
      end

      it "renders a JSON response with the new employee" do
        post employees_url, params: valid_attributes , as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new employee" do
        expect {
          post employees_url, params: invalid_attributes , as: :json
        }.to change(Employee, :count).by(0)
      end

      it "renders a JSON response with errors for the new employee" do
        post employees_url, params: invalid_attributes , as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json")
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        { name: "New employee Name"}
      }
      it "updates the requested employee" do
        employee = Employee.create! valid_attributes
        patch employee_url(employee), params: new_attributes , as: :json
        employee.reload
        expect(response).to have_http_status(:ok)
        expect(employee.name).to eq("New employee Name")
      end

      it "renders a JSON response with the employee" do
        employee = Employee.create! valid_attributes
        patch employee_url(employee), params: new_attributes , as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq("application/json")
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the employee" do
        employee = Employee.create! valid_attributes
        patch employee_url(employee), params: invalid_attributes , as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json")
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested employee" do
      employee = Employee.create! valid_attributes
      expect {
        delete employee_url(employee), as: :json
      }.to change(Employee, :count).by(-1)
    end
  end

end
