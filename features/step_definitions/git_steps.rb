Given(/^the Github homebrew repository is not clone yet$/) do
  # @todo  Mock the filesystem as it is too slow and files aren't deleted
  # when next test is executed
  FileUtils.rm_rf(AppConfig.homebrew.git_repository.location)
end

Given(/^the Github homebrew repository has been cloned$/) do
  step 'the Github homebrew repository is not clone yet'

  git_working_dir = File.join(
    AppConfig.homebrew.git_repository.location,
    AppConfig.homebrew.git_repository.name
  )

  Git::Lib.new.run_command(
    "git clone \"--\" \"git-repo.url\" \"#{git_working_dir}\""
  )
end

Given(/^the Github homebrew repository has some formulae$/) do
  HomebrewFormula.new_formula(
    name: 'A2ps',
    homepage: 'http://www.gnu.org/software/a2ps/'
  )
  HomebrewFormula.new_formula(
    name: 'A52dec',
    homepage: 'http://liba52.sourceforge.net/',
    version: '2.09'
  )
end

Given(/^the Github homebrew repository has the following formula:$/) do |table|
  homebrew_formula = table.rows_hash
  HomebrewFormula.new_formula(
    name: homebrew_formula['Name'],
    homepage: homebrew_formula['Homepage']
  )
end

Given(/^the Github homebrew repository has a new formula$/) do
  HomebrewFormula.new_formula(name: 'llvm', homepage: 'http://llvm.org/')
end

Given(/^the Github homebrew repository has the (?:new )?(\w+) formula with homepage "(.*?)"$/) do |name, homepage|
  HomebrewFormula.new_formula(name: name, homepage: homepage)
end

Given(/^the Github homebrew repository has an deleted formula$/) do
  # Create a new formula in the DB
  # without adding it to the HomebrewFormula collection
  # When HomebrewFormula will create the formulas,
  # the following forumla will not been found and then flagged as deleted
  Homebrew::Formula.create!(filename: 'arm', name: 'Arm')
end

Given(/^the Github homebrew repository has a formula having multiple formula classes$/) do
  HomebrewFormula.new_formula(
    name: 'llvm',
    homepage: 'http://llvm.org/',
    others: [
      { name: 'clang', homepage: 'http://llvm.org/' }
    ]
  )
end

Given(/^the Github homebrew repository has an updated formula$/) do
  HomebrewFormula.new_formula(
    name: 'A52dec',
    homepage: 'http://liba52.sourceforge.net/',
    version: '2.10'
  )
end

Given(/^the Github homebrew repository doesn't have update$/) do
  # Nothing todo yet here.
end

Given(/^the Github homebrew repository has a formula having backticks$/) do
  HomebrewFormula.new_formula(
    name: 'Lsyncd',
    homepage: 'https://github.com/axkibe/lsyncd',
    code: 'osx_version = `sw_vers -productVersion`.strip'
  )
end

Given(/^the Github homebrew repository has a formula with (dependencies|conflicts( with a reason( on multiple lines| with because issue)?)?)$/) do |dependencies_or_conflicts, with_reason, multiple_lines_or_because|
  attributes = {
    name: 'Xpdf',
    homepage: 'http://www.foolabs.com/xpdf/'
  }

  if dependencies_or_conflicts == 'dependencies'
    attributes.merge!(
      depends_on: %w(lesstif x11)
    )
  else
    if with_reason
      attributes.merge!(
        conflicts_with: {
          formulas: %w(pdf2image poppler),
          because: 'xpdf, pdf2image, and poppler install conflicting executables',
          on_multiple_lines: multiple_lines_or_because == ' on multiple lines',
          because_issue: multiple_lines_or_because == ' with because issue'
        }
      )
    else
      attributes.merge!(
        conflicts_with: {
          formulas: 'pdf2image'
        }
      )
    end
  end

  HomebrewFormula.new_formula(attributes)
end

Given(/^the Github homebrew repository has a formula with an external dependency$/) do
  HomebrewFormula.new_formula(
    name: 'Cliclick',
    homepage: 'http://www.bluem.net/jump/cliclick/',
    depends_on: 'Xcode'
  )
end

When(/^the background task to get or update the formulae is executed$/) do
  HomebrewFormulaImportWorker.new.perform
end

Then(/^the Github homebrew repository should be cloned$/) do
  expect(File.exists?(AppConfig.homebrew.git_repository.location)).to be_truthy
end
