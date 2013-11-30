Given /^some formulas exist$/ do
  Homebrew::Formula.create!(filename: "a2ps", name: "A2ps", homepage: "http://www.gnu.org/software/a2ps/")
  HomebrewFormula.new_formula(name: "A2ps", homepage: "http://www.gnu.org/software/a2ps/")
  Homebrew::Formula.create!(filename: "a52dec", name: "A52dec", homepage: "http://liba52.sourceforge.net/")
  HomebrewFormula.new_formula(name: "A52dec", homepage: "http://liba52.sourceforge.net/")
  @homebrew_formula_count = Homebrew::Formula.count
end

Given /^following Homebrew formula exists:$/ do |formula|
  formula = formula.rows_hash
  formula["filename"] = formula["name"] if formula["filename"].blank?
  Homebrew::Formula.create!(formula)
end

Given /^the (\w+) formula has the description "(.*?)"$/ do |name, description|
  unless formula = Homebrew::Formula.find_by_name(name)
    raise "Unable to find an Homebrew::Formula with name \"#{name}\""
  end
  formula.update_attribute(:description, description)
end

Given /^the (\w+) formula with homepage "(.*?)" exists$/ do |name, homepage|
  Homebrew::Formula.create!(filename: name.downcase, name: name, homepage: homepage)
end

Given /^the automatically extracted description for the (\w+) formula is "(.*?)"$/ do |name, description|
  unless formula = Homebrew::Formula.find_by_name(name)
    raise "Unable to find an Homebrew::Formula with name \"#{name}\""
  end
  formula.update_attributes(description: description, description_automatic: true)
end

When /^I click the formula "(.*?)"$/ do |formula|
  click_on formula
end

When /the background task to fetch formula description runs/ do
  FormulaDescriptionFetchWorker.new.perform(Homebrew::Formula.last.id)
end

When /^I request to update the formula description$/ do
  click_on "clicking this link"
end

Then /^there should be some formulas in the database$/ do
  Homebrew::Formula.exists?.should be_true, "Expected to have formula in the database but didn't."
end

Then /^formulas should not been updated$/ do
  Homebrew::Formula.select(:created_at, :updated_at).all? do |formula|
    formula.created_at.to_i.should == formula.updated_at.to_i
  end
end

Then /^no new formula should be in the database$/ do
  expect(Homebrew::Formula.count).to eq(@homebrew_formula_count)
end

Then /^a new formula should be available in the database$/ do
  formula = Homebrew::Formula.select(:created_at, :updated_at).last
  formula.created_at.to_i.should == formula.updated_at.to_i # Comparing date time isn't working
  expect(Homebrew::Formula.count).to eq(@homebrew_formula_count.to_i + 1)
end

Then /^a formula should be updated$/ do
  Homebrew::Formula.select(:created_at, :updated_at).to_a.detect do |formula|
    formula.created_at != formula.updated_at
  end.should be_present, "Expected to have a formula with a different date of update than creation but didn't"
end

Then /^a formula should be flagged as deleted in the database$/ do
  Homebrew::Formula.where("touched_on < ?", Date.today).count.should == 1
end

Then /^the formula (\w+) should have the following description:$/ do |name, description|
  unless formula = Homebrew::Formula.find_by_name(name)
    raise "Unable to find an Homebrew::Formula with name \"#{name}\""
  end
  formula.description.should == description
end

Then /^I should see the (\w+) formula description automatically extracted from the homepage$/ do |name|
  unless formula = Homebrew::Formula.find_by_name(name)
    raise "Unable to find an Homebrew::Formula with name \"#{name}\""
  end

  xpath = "//blockquote/p[normalize-space(.)='#{formula.description}']"
  description_source = "#{name} homepage"
  xpath << "/../small[normalize-space(.)='Extracted automatically from #{description_source}']"
  xpath << "/cite[@title='#{formula.homepage}' and normalize-space(.)='#{description_source}']"

  visit formula_path(name)
  page.should have_xpath(xpath)
end
