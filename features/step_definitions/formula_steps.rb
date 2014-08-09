Given(/^on formulas exist$/) do
  Homebrew::Formula.destroy_all
end

Given(/^a formula with a description exists$/) do
  Homebrew::Formula.create!(filename: 'libnice', name: 'Libnice',
                            description: 'Libnice is a library.')
end
