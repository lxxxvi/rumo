# frozen_string_literal: true

class DeviseCreateHosts < ActiveRecord::Migration[6.0]
  def change
    create_table :hosts do |t|
      t.string :name, null: false
      t.string :url_identifier, null: false
      t.string :country_time_zone_identifier, null: false, default: 'Europe/Zurich'
      ## Database authenticatable
      t.string :email,              null: false
      t.string :encrypted_password, null: false

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      # t.integer  :sign_in_count, default: 0, null: false
      # t.datetime :current_sign_in_at
      # t.datetime :last_sign_in_at
      # t.inet     :current_sign_in_ip
      # t.inet     :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      t.index :name, unique: true
      t.index :url_identifier, unique: true
      t.index :email, unique: true
      t.index :reset_password_token, unique: true

      t.timestamps null: false
    end

    # add_index :hosts, :confirmation_token,   unique: true
    # add_index :hosts, :unlock_token,         unique: true
  end
end
