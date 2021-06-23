class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies do |t|
      t.string :name
      t.integer :reqd_no_of_employees
      t.integer :parent_id

      t.timestamps
    end
  end
end
