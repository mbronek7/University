class CreateCars < ActiveRecord::Migration[5.2]
  def change
    create_table :cars do |t|
      t.string :registration_number
      t.string :fuel
      t.string :name
      t.integer :year_of_production
      t.date :date_of_first_yerestration

      t.timestamps
    end
  end
end
