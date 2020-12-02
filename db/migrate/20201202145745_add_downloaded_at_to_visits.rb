class AddDownloadedAtToVisits < ActiveRecord::Migration[6.0]
  def change
    add_column :visits, :downloaded_at, :datetime, null: true, default: nil
  end
end
