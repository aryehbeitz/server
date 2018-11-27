class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.string  :content
      t.integer :entity_id
      t.string  :entity_type
      t.string  :comment_type
      t.integer :user_id

      t.timestamps
    end
  end
end
