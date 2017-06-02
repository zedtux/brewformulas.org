Given(/^a formula with a description exists$/) do
  Homebrew::Formula.create!(filename: 'libnice', name: 'Libnice',
                            description: 'Libnice is a library.')
end

Then(/^the formula (.*?) should have the version (.*?)$/) do |name, version|
  formula = Homebrew::Formula.find_by(name: name)
  expect(formula.version).to eql(version)
end
