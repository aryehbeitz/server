class AddLastCallToWitnessYears < ActiveRecord::Migration[5.2]
  def change
    add_column :witness_years, :last_call, :string
  end
end
