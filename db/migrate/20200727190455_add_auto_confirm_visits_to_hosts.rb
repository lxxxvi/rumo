class AddAutoConfirmVisitsToHosts < ActiveRecord::Migration[6.0]
  def change
    add_column :hosts, :auto_confirm_visits, :boolean, null: true, default: false
  end
end
