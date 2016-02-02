Then(/^the meta description tag should be "(.*?)"$/) do |description|
  expect(page).to have_css("meta[name='description'][content=\"#{description}\"]",
                           visible: false)
end
