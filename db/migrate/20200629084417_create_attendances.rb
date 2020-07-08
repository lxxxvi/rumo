class CreateAttendances < ActiveRecord::Migration[6.0]
  def change
    create_table :attendances do |t|
      t.date :attended_on, null: false
      t.string :token, null: false
      t.string :name, null: true
      t.string :contact, null: false
      t.datetime :confirmed_at, null: true

      t.index %[token], unique: true
      t.index %i[attended_on contact], unique: true

      t.timestamps
    end
  end
end
