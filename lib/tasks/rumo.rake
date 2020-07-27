namespace :rumo do
  desc 'Remove expired visits'
  task remove_expired: :environment do
    VisitsRetentionService.remove_expired!
  end
end
