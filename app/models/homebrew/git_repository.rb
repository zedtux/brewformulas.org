module Homebrew
  #
  # Homebrew Git repository interface
  #
  # @author [guillaumeh]
  #
  module GitRepository
    #
    # Get the Homebrew formulas from Github.com
    #
    # In the case of the source code folder is missing
    # this method will clone the repository (without the history)
    # otherwise just call `git pull`.
    #
    def self.fetch_up_to_date_git_repository
      git = if File.exist?(AppConfig.homebrew.git_repository.location)
              open_git_repository
            else
              path = File.join(AppConfig.homebrew.git_repository.location,
                               AppConfig.homebrew.git_repository.name)
              # Create the location path
              FileUtils.mkdir_p(path)
              # Clone the Git repo to the location path
              clone_git_repository
            end

      # Update the code to the HEAD version
      git.pull
    end

    def self.open_git_repository
      location = AppConfig.homebrew.git_repository.location
      name = AppConfig.homebrew.git_repository.name
      path = File.join(location, name)
      Rails.logger.info "Reusing Git repository #{name} from #{path}"
      Git.open(path)
    end

    def self.clone_git_repository
      url = AppConfig.homebrew.git_repository.url
      name = AppConfig.homebrew.git_repository.name
      path = AppConfig.homebrew.git_repository.location
      Rails.logger.info "Cloning Git repository #{name} from #{url} to #{path}"
      Git.clone(url, name, path: path, depth: 1)
    end
  end
end
