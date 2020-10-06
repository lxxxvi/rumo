class AddNotesTextToHost < ActiveRecord::Migration[6.0]
  def change
    add_column :hosts, :notes_text, :string, null: true
  end
end
