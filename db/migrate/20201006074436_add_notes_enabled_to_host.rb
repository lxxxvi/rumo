class AddNotesEnabledToHost < ActiveRecord::Migration[6.0]
  def change
    add_column :hosts, :notes_enabled, :boolean, null: false, default: true
  end
end
