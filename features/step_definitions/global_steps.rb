Given(/^no ([^"]+) exist(?: in ([^"]+))?$/) do |model_name, namespace|
  model_name = model_name.gsub(/ /, '_').classify
  namespace = namespace.gsub(/ /, '_').classify if namespace
  model = if namespace
            "#{namespace}::#{model_name}"
          else
            model_name
          end.constantize
  model.destroy_all
  ActiveRecord::Base.connection.reset_pk_sequence!(model.table_name)
  ActiveRecord::Base.connection.execute("REINDEX TABLE #{model.table_name}")
end

Given(/^following (.+s) exist:$/) do |item, table|
  table.hashes.each do |hash|
    step "following #{item.singularize} exists:", table(hash.to_a)
  end
end

When(/^I click the (.*?) formula name$/) do |formula_name|
  click_on formula_name
end

When(/^I scroll to the bottom of the page$/) do
  page.execute_script 'window.scrollBy(0,10000)'
end

Then(/^show me the page$/) do
  screenshot_and_save_page
end

Then(/^show me a screenshot$/) do
  saver = Capybara::Screenshot::Saver.new(Capybara, Capybara.page, false)
  saver.save
end

Then(/^I should see "(.*?)"$/) do |something|
  expect(page).to have_content(something)
end

Then(
  /^I should see the (success|error|info)? alert "(.*?)"( on the homepage)?$/
) do |type, message, on_homepage|
  expect(current_path).to eq(root_path) if on_homepage

  type = case type
         when 'error', 'success', 'info'
           type
         else
           'info'
         end

  xpath = ["//div[contains(@class, 'alert') and"]
  xpath << "contains(@class, '#{type}') and"
  xpath << "contains(normalize-space(.),\"#{message}\")]"
  page.should have_xpath(xpath.join(' '))
end

Then(/^the page title should be "(.*?)"$/) do |title|
  expect(page).to have_title(title)
end
