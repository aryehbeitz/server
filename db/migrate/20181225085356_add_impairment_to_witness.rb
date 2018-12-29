class AddImpairmentToWitness < ActiveRecord::Migration[5.2]
  def change
    add_column :witnesses, :wheelchair, :string, default: "false"
    add_column :witnesses, :hearing_impairment, :boolean
    add_column :witnesses, :visual_impairment, :boolean
  end
end
