class AddToWitnesses < ActiveRecord::Migration[5.2]
  def change
    add_column :witnesses, :free_text, :string
    add_column :witnesses, :additional_phone, :string
    add_column :witnesses, :archived, :boolean
  end
end
