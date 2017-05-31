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
      git = if git_repository_cloned?
              open_git_repository
            else
              # Create the location path
              FileUtils.mkdir_p(cloned_repository_path)
              # Clone the Git repo to the location path
              clone_git_repository
            end

      # Update the code to the HEAD version
      git.pull
    end

    def self.open_git_repository
      name = Rails.configuration.homebrew.git_repository.name
      path = cloned_repository_path
      Rails.logger.info "Reusing Git repository #{name} from #{path}"
      Git.open(path)
    end

    def self.clone_git_repository
      url = Rails.configuration.homebrew.git_repository.url
      name = Rails.configuration.homebrew.git_repository.name
      path = Rails.configuration.homebrew.git_repository.location
      Rails.logger.info "Cloning Git repository #{name} from #{url} to #{path}"
      Git.clone(url, name, path: path, depth: 1)
    end

    def self.cloned_repository_path
      File.join(Rails.configuration.homebrew.git_repository.location,
                Rails.configuration.homebrew.git_repository.name)
    end

    def self.git_repository_cloned?
      File.exist?(cloned_repository_path)
    end
  end
end
