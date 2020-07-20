class CreateVisits < ActiveRecord::Migration[6.0]
  def change
    create_table :visits do |t|
      t.references :host, null: false, index: true, foreign_key: true
      t.datetime :visited_at, null: false
      t.string :uuid, null: false
      t.string :token, null: false
      t.string :name, null: true
      t.string :contact, null: false
      t.string :notes, null: true
      t.datetime :confirmed_at, null: true

      t.index %i[host_id token], unique: true

      t.timestamps
    end
  end
end
