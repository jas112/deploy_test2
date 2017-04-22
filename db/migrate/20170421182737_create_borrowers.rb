class CreateBorrowers < ActiveRecord::Migration
  def change
    create_table :borrowers do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest
      t.text :loan_reason
      t.text :loan_description
      t.integer :ammount_needed
      t.integer :ammount_raised

      t.timestamps null: false
    end
  end
end
