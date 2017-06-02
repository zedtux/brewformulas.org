module ApplicationHelper
  def homebrew_new_issue_github_url(options = {})
    base_url = Rails.configuration.homebrew.git_repository.url.gsub(/.git$/, '')
    base_url << '/issues/new'
    base_url << "?title=#{options[:title]}" if options.key?(:title)
    base_url
  end
end
