Given /^the Github homebrew repository is not clone yet$/ do
  # @todo  Mock the filesystem as it is too slow and files aren't deleted when next test is executed
  FileUtils.rm_rf(AppConfig.homebrew.git_repository.location)
end

Given /^the Github homebrew repository has been cloned$/ do
  step "the Github homebrew repository is not clone yet"

  git_working_dir = File.join(AppConfig.homebrew.git_repository.location, AppConfig.homebrew.git_repository.name)
  Git::Lib.new.run_command("git clone \"--\" \"git-repo.url\" \"#{git_working_dir}\"")
end

Given /^the Github homebrew repository has some formulae$/ do
  HomebrewFormula.new_formula(name: "A2ps", homepage: "http://www.gnu.org/software/a2ps/")
  HomebrewFormula.new_formula(name: "A52dec", homepage: "http://liba52.sourceforge.net/", version: "2.09")
end

Given /^the Github homebrew repository has the following formula:$/ do |table|
  homebrew_formula = table.rows_hash
  HomebrewFormula.new_formula(name: homebrew_formula["Name"], homepage: homebrew_formula["Homepage"])
end

Given /^the Github homebrew repository has a new formula$/ do
  HomebrewFormula.new_formula(name: "llvm", homepage: "http://llvm.org/")
end

Given /^the Github homebrew repository has an deleted formula$/ do
  # Create a new formula in the DB without adding it to the HomebrewFormula collection
  # When HomebrewFormula will create the formulas, the following forumla will not been
  # found and then flagged as deleted
  Homebrew::Formula.create!(filename: "arm", name: "Arm")
end

Given /^the Github homebrew repository has a formula having multiple formula classes$/ do
  HomebrewFormula.new_formula(
    {
      name: "llvm",
      homepage: "http://llvm.org/",
      others: [
        {name: "clang", homepage: "http://llvm.org/"}
      ]
    }
  )
end

Given /^the Github homebrew repository has an updated formula$/ do
  HomebrewFormula.new_formula(name: "A52dec", homepage: "http://liba52.sourceforge.net/", version: "2.10")
end

Given /^the Github homebrew repository doesn't have update$/ do
  # Nothing todo yet here.
end

When /^the background task to get or update the formulae is executed$/ do
  HomebrewGit.new.perform
end

Then /^the Github homebrew repository should be cloned$/ do
  File.exists?(AppConfig.homebrew.git_repository.location).should be_true
end
