When(/^I go to brewformulas.org$/) do
  visit '/'
end

When(/^I go to the formula (\w+) on brewformulas.org$/) do |name|
  visit formula_path(name)
end

When(/^I go to the imports on brewformulas.org$/) do
  visit imports_path
end

When(/^I search a formula with "(.*)"$/) do |name_or_keyword|
  fill_in 'search_terms', with: name_or_keyword
  click_on 'formula_search'
  @searched_for_terms = name_or_keyword
end

Then(/^I should not see any formula$/) do
  nothing_found_message = I18n.t('messages.sorry_nothing_found',
                                 terms: @searched_for_terms)
  # Removes HTML tags
  nothing_found_message = ActionView::Base.full_sanitizer
                                          .sanitize(nothing_found_message)
  expect(page).to have_content(nothing_found_message)
end

Then(/^I should see the (.*) Homebrew formulas?$/) do |formulas|
  formulas.gsub!(/and/, ' ') if formulas.include?('and')
  formulas.gsub!(/,/, ' ')
  formulas.gsub!(/  /, ' ')

  base_xpath = '//div[@id="pagination"]//div[contains(@class, "card")]' \
               '//a[normalize-space(.)="'

  formulas.split.each do |formula|
    expect(page).to have_xpath(base_xpath.dup << formula << '"]')
  end
end
