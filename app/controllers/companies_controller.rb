class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :update, :destroy, :set_required_amount_of_employees, :remove_employees]

  def index
    @companies = Company.all
  end

  def show
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      render :show, status: :created, location: @company
    else
      render json: @company.errors, status: :unprocessable_entity
    end
  end

  def update
    if @company.update(company_params)
      render :show, status: :ok, location: @company
    else
      render json: @company.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @company.destroy
      render json: {success:['Deleted.'], status: :ok}
    else
      render json: {errors:['Not able to delete company.'], status: :unprocessable_entity}
    end
  end

  def remove_employees
    # Remove the employee/employees of the given company
    employee_ids = params[:employee_ids].split(",") if params[:employee_ids]
    if Company.delete_employees(employee_ids)
      render json: {success:['Deleted the employees!'], status: :ok}
    else
      render json: {errors:['Not able to delete employees.'], status: :unprocessable_entity}
    end
  end

  def set_required_amount_of_employees
    # Update the parent company's reqd no of employees from the params company_id & required_no_of_employees
    if @company && @company.parent_id.blank?
      if @company.update(reqd_no_of_employees: params[:required_no_of_employees])
        render :show, status: :ok, location: @company
      else
        render json: @company.errors, status: :unprocessable_entity
      end
    else
      render json: {errors:['Not able set amount of employees for sub companies.'], status: :unprocessable_entity}
    end
  end

  def companies_with_less_required_employees
    @companies = Company.companies_less_than_target_employees
    if @companies.present?
      render json: @companies, status: :ok
    else
      render json: {errors:['No companies present with less than target!'], status: :unprocessable_entity}
    end
  end

  private
    def set_company
      @company = Company.find(params[:id])
    end

    def company_params
      params.permit(:cid, :name, :location, :reqd_no_of_employees, :parent_id)
    end
end
