require 'rails_helper'

RSpec.describe "/companies", type: :request do
  let(:valid_attributes) {
    {
      :cid => "C101", 
      :name => "My Personal company"
    }
  }

  let(:invalid_attributes) {
    {
      :cid => 22, 
      :name => ""
    }
  }

  describe "GET /index" do
    it "renders a successful response" do
      Company.create! valid_attributes
      get companies_url, as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      company = Company.create! valid_attributes
      get company_url(company), as: :json
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new company" do
        expect {
          post companies_url, params: valid_attributes , as: :json
        }.to change(Company, :count).by(1)
      end

      it "renders a JSON response with the new company" do
        post companies_url, params: valid_attributes , as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new company" do
        expect {
          post companies_url, params: invalid_attributes , as: :json
        }.to change(Company, :count).by(0)
      end

      it "renders a JSON response with errors for the new company" do
        post companies_url, params: invalid_attributes , as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json")
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        { name: "New Company Name"}
      }
      it "updates the requested company" do
        company = Company.create! valid_attributes
        patch company_url(company), params: new_attributes , as: :json
        company.reload
        expect(response).to have_http_status(:ok)
        expect(company.name).to eq("New Company Name")
      end

      it "renders a JSON response with the company" do
        company = Company.create! valid_attributes
        patch company_url(company), params: new_attributes , as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq("application/json")
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the company" do
        company = Company.create! valid_attributes
        patch company_url(company), params: invalid_attributes , as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json")
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested company" do
      company = Company.create! valid_attributes
      expect {
        delete company_url(company), as: :json
      }.to change(Company, :count).by(-1)
    end
  end

  describe "Delete employees in a company" do
    it "should delete the employees in a company by passing employee_id" do
      company = Company.create! valid_attributes
      employee = FactoryBot.create(:employee, company_id: company.id)
      params = {:id=> company.id, :employee_ids => employee.id.to_s}
      post '/companies/remove_employees', params: params, as: :json
      expect(response).to be_successful
    end
  end
end
