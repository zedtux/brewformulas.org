Given /^no ([^"]+) exist(?: in ([^"]+))?$/ do |model_name, namespace|
  model_name = model_name.gsub(/ /, "_").classify
  namespace = namespace.gsub(/ /, "_").classify if namespace
  model = if namespace
    "#{namespace}::#{model_name}"
  else
    model_name
  end.constantize
  model.destroy_all
  ActiveRecord::Base.connection.reset_pk_sequence!(model.table_name)
  ActiveRecord::Base.connection.execute("REINDEX TABLE #{model.table_name}")
end

Given /^following (.+s) exist:$/ do |item, table|
  table.hashes.each do |hash|
    step "following #{item.singularize} exists:", table(hash.to_a)
  end
end

Then /^show me the page$/ do
  save_and_open_page
end

Then /^I should see "(.*?)"$/ do |something|
  expect(page).to have_content(something)
end
