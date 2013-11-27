namespace :brewformulas do
  namespace :sidekiq do
    desc "Start all schedule jobs"
    task start: :environment do
      HomebrewFormulaImportWorker.perform_async
    end
  end
end
