class AddLocationToCompanies < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :location, :string
  end
end
