class AddSpecialNeedsToWitnesses < ActiveRecord::Migration[5.2]
  def change
    add_column :witnesses, :special_needs, :string
  end
end
