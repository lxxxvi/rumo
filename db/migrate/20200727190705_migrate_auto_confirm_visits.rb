class MigrateAutoConfirmVisits < ActiveRecord::Migration[6.0]
  # rubocop:disable Rails/SkipsModelValidations
  def change
    Host.update_all(auto_confirm_visits: false)
  end
  # rubocop:enable Rails/SkipsModelValidations
end
