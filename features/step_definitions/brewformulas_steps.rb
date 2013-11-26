When /^I go to brewformulas.org$/ do
  visit root_url
end

When /^I search a formula with "(.*)"$/ do |name_or_keyword|
  fill_in "Formula", with: name_or_keyword
  click_on "Search"
end

Then /^I should not see any formula$/ do
  expect(page).to have_content "No formula found."
end

Then /^I should see the (.*) Homebrew formulas?$/ do |formulas|
  formulas.gsub!(/and/, " ") if formulas.include?("and")
  formulas.gsub!(/,/, " ")
  formulas.gsub!(/  /, " ")
  formulas.split.each do |formula|
    page.should have_xpath("//div[@class='list-group']/a[@class='list-group-item']/h4[@class='list-group-item-heading' and contains(normalize-space(.), '#{formula}')]")
  end
end
