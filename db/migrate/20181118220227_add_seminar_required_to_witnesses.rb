class AddSeminarRequiredToWitnesses < ActiveRecord::Migration[5.2]
  def change
    add_column :witnesses, :seminar_required, :boolean
  end
end
