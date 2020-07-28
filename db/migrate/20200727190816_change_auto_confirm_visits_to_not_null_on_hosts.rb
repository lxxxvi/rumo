class ChangeAutoConfirmVisitsToNotNullOnHosts < ActiveRecord::Migration[6.0]
  def change
    change_column_null :hosts, :auto_confirm_visits, false
  end
end
