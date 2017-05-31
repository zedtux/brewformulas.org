Then(
  /^I should see the names, filenames and descriptions checkboxes checked$/
) do
  expect('#search_names:checked').to be_present
  expect('#search_filenames:checked').to be_present
  expect('#search_descriptions:checked').to be_present
end
