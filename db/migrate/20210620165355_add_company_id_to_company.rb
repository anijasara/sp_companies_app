class AddCompanyIdToCompany < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :cid, :string
  end
end
