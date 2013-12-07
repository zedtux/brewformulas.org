namespace :brewformulas do
  desc "Dump Formula homepage into a fixture file"
  task :dump_homepage, [:formula_name] => [:environment] do |t, args|
    formula = Homebrew::Formula.find_by!(name: args[:formula_name])

    raise "Formula #{formula.name} has no homepage!" unless formula.homepage

    fixture_path = Rails.root.join("features", "fixtures", "webmock", formula.name.downcase)
    raise "A fixture file already exists for Formula #{formula.name}!" if File.exists?(fixture_path)

    puts "Getting homepage..."
    homepage = Homebrew::HomepageContent.new(formula)

    puts "Saving homepage..."
    FileUtils.mkdir_p(fixture_path) unless File.exists?(fixture_path)
    File.open(File.join(fixture_path, "index.html"), "w") {|file|
      file.write(homepage.fetch)
    }
    puts "#{formula.name}'s homepage successfully dumped in #{fixture_path}."
  end
end
