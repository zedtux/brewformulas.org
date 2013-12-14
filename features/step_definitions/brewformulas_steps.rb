When /^I go to brewformulas.org$/ do
  visit root_url
end

When /^I go to the formula (\w+) on brewformulas.org$/ do |name|
  visit formula_path(name)
end

When /^I go to the imports on brewformulas.org$/ do
  visit imports_path
end

When /^I search a formula with "(.*)"$/ do |name_or_keyword|
  fill_in 'Formula', with: name_or_keyword
  click_on 'Search'
end

Then /^I should not see any formula$/ do
  expect(page).to have_content 'No formula found.'
end

Then /^I should see the (.*) Homebrew formulas?$/ do |formulas|
  formulas.gsub!(/and/, ' ') if formulas.include?('and')
  formulas.gsub!(/,/, ' ')
  formulas.gsub!(/  /, ' ')

  base_xpath = '//div[@class="list-group"]/a[@class="list-group-item"]'
  base_xpath << '/h4[@class="list-group-item-heading" '
  base_xpath << 'and contains(normalize-space(.), "'

  formulas.split.each do |formula|
    page.should have_xpath(base_xpath.dup << formula << '")]')
  end
end
