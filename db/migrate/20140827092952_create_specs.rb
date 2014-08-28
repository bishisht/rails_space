class CreateSpecs < ActiveRecord::Migration
  def change
    create_table :specs do |t|
      t.integer :user_id     
      t.string "first_name"
      t.string "last_name"
      t.string "gender"
      t.date "birthdate"
      t.string "occupation"
      t.string "city"
      t.string "state"
      t.string "zip_code"
      t.timestamps
    end
  end
end
