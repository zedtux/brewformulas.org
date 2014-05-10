Given(/^an import is running$/) do
  Import.create
end

Given(/^an import has finished on (success|failure) since (less|more) than a minute$/) do |success_failure, less_more|
  Import.create(
    ended_at: (less_more == 'less' ? 56 : 70).seconds.since,
    success: success_failure == 'success'
  )
end

Given(/^all formulas have been touched during the latest import(?: excepted (.*?))?$/) do |excepted|
  import = Import.success.last
  Homebrew::Formula.all.map do |formula|
    next if formula.name == excepted
    formula.update_attribute(:touched_on, import.ended_at.to_date)
  end
end

Given(/^the new "(.*?)" formula has been imported$/) do |name|
  Homebrew::Formula.create(name: name, filename: name.downcase)
end

Then(/^I should see there is no imports$/) do
  expect(page).to have_content('No imports yet.')
end

Then(/^I should see a (running|finished) import(?: with (success|failure))? since (.*?)$/) do |execution, success_failure, duration|
  xpath = '//table//tr/'
  xpath << 'td[@class="execution" and '
  xpath << "normalize-space(.)='#{execution.capitalize}']"
  xpath << "/../td[@class='duration' and normalize-space(.)='#{duration}']"
  if success_failure
    xpath << '/../td[@class="status" and '
    xpath << "normalize-space(.)='#{success_failure.capitalize}']"
  end
  page.should have_xpath(xpath)
end
