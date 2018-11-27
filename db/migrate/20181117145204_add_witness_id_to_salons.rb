class AddWitnessIdToSalons < ActiveRecord::Migration[5.2]
  def change
    add_column :salons, :witness_id, :integer
  end
end
