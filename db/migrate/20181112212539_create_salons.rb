class CreateSalons < ActiveRecord::Migration[5.2]
  def change
    create_table :salons do |t|
      t.timestamps null: false

      t.integer   :org_id

      t.integer  :country_region_city_id
      t.string   :address

      t.integer  :floor
      t.boolean  :elevator
      t.date     :event_date
      t.datetime   :event_time

      t.string   :event_language,             :default => "hebrew"

      t.boolean  :survivor_needed
      t.boolean  :strangers,  default: true

      t.text     :public_text

      t.integer  :max_guests
      t.text     :inside_text

      t.integer     :user_id
    end
  end
end
