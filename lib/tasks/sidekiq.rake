namespace :brewformulas do
  namespace :sidekiq do
    desc "Start all schedule jobs"
    task start: :environment do
      HomebrewGit.perform_async
    end
  end
end
