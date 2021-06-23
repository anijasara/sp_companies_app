class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :update, :destroy]

  def index
    @companies = Employee.all
  end

  def show
  end

  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      render :show, status: :created, location: @employee
    else
      render json: @employee.errors, status: :unprocessable_entity
    end
  end

  def update
    if @employee.update(employee_params)
      render :show, status: :ok, location: @employee
    else
      render json: @employee.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @employee.destroy
      render json: {success:['Deleted.'], status: :ok}
    else
      render json: {errors:['Not able to delete employee.'], status: :unprocessable_entity}
    end
  end

  private
    def set_employee
      @employee = Employee.find(params[:id])
    end

    def employee_params
      params.permit(:emp_id, :name, :company_id)
    end
end
