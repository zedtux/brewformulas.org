Given /^some formulas exist$/ do
  Homebrew::Formula.create!(name: "A2ps", homepage: "http://www.gnu.org/software/a2ps/")
  HomebrewFormula.new_formula(name: "A2ps", homepage: "http://www.gnu.org/software/a2ps/")
  Homebrew::Formula.create!(name: "A52dec", homepage: "http://liba52.sourceforge.net/")
  HomebrewFormula.new_formula(name: "A52dec", homepage: "http://liba52.sourceforge.net/")
  @homebrew_formula_count = Homebrew::Formula.count
end

Given /^following Homebrew formula exists:$/ do |formula|
  formula = formula.rows_hash
  Homebrew::Formula.create!(formula)
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
  expect(Homebrew::Formula.count).to eq(@homebrew_formula_count + 1)
end

Then /^a formula should be updated$/ do
  Homebrew::Formula.select(:created_at, :updated_at).to_a.detect do |formula|
    formula.created_at != formula.updated_at
  end.should be_present, "Expected to have a formula with a different date of update than creation but didn't"
end

Then /^a formula should be flagged as deleted in the database$/ do
  Homebrew::Formula.where("touched_on < ?", Date.today).count.should == 1
end
