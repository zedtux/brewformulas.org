require "open-uri"
require "open_uri_redirections"

namespace :brewformulas do
  desc "Dump Formula homepage into a fixture file"
  task :dump_homepage, [:formula_name] => [:environment] do |t, args|
    formula = Homebrew::Formula.find_by!(name: args[:formula_name])

    raise "Formula #{formula.name} has no homepage!" unless formula.homepage

    fixture_path = Rails.root.join("features", "fixtures", "webmock", formula.name.downcase)
    raise "A fixture file already exists for Formula #{formula.name}!" if File.exists?(fixture_path)

    puts "Getting homepage..."
    page_content = open(formula.homepage, allow_redirections: :all).read
    page_content.gsub!(/&shy;/, "") # Remove all Hyphen
    page_content = page_content.encode(
      "UTF-8",
      invalid: :replace,
      undef: :replace,
      replace: "?"
    ) # Manage non UTF-8 characters

    puts "Saving homepage..."
    FileUtils.mkdir_p(fixture_path) unless File.exists?(fixture_path)

    File.open(File.join(fixture_path, "index.html"), "w") {|file| file.write(page_content)}

    puts "#{formula.name}'s homepage successfully dumped in #{fixture_path}."
  end
end
