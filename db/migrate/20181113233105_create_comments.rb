class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.string :entity_type

      t.timestamps
    end
  end
end
