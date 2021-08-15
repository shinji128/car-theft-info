class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :Posts do |t|
      t.string :car_name, null: false
      t.string :car_model
      t.string :car_number, null: false
      t.string :stole_location, null: false
      t.string :contact, null: false
      t.datetime :stole_time
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
