namespace :brewformulas do
  desc 'Dump Formula homepage into a fixture file'
  task :dump_homepage, [:formula_name] => [:environment] do |_t, args|
    formula = Homebrew::Formula.find_by!(name: args[:formula_name])

    fail "Formula #{formula.name} has no homepage!" unless formula.homepage

    fixture_path = Rails.root.join('features', 'fixtures',
                                   'webmock', formula.name.downcase)
    fail "A fixture file already exists for Formula #{formula.name}!" if File.exist?(fixture_path)

    puts 'Getting homepage...'
    homepage = Homepage.new(formula.homepage)

    puts 'Saving homepage...'
    FileUtils.mkdir_p(fixture_path) unless File.exist?(fixture_path)
    File.open(File.join(fixture_path, 'index.html'), 'w') do|file|
      file.write(homepage.fetch)
    end
    puts "#{formula.name}'s homepage successfully dumped in #{fixture_path}."
  end
end
