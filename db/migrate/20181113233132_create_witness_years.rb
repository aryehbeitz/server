class CreateWitnessYears < ActiveRecord::Migration[5.2]
  def change
    create_table :witness_years do |t|
      t.integer :witness_id
      t.integer :year

      t.boolean :available_day1
      t.boolean :available_day2
      t.boolean :available_day3
      t.boolean :available_day4
      t.boolean :available_day5
      t.boolean :available_day6
      t.boolean :available_day7

      t.boolean :can_morning
      t.boolean :can_afternoon
      t.boolean :can_evening

      t.boolean :first_staff_contacted

      t.timestamps
    end
  end
end
