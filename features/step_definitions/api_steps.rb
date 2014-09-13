Given(/^I send a GET request in JSON to the root url$/) do
  get '/', format: 'json'
end

Given(/^I send a GET request in JSON to the not-existing formula url$/) do
  get '/this-formula-doesnt-exist.json'
end

Given(/^I send a GET request in JSON to the a52dec formula url$/) do
  get '/a52dec.json'
end

Then(/^I should receive a (404|415) HTTP error code$/) do |code|
  expect(last_response.status).to eql(code.to_i)
end

Then(/^I should receive a 200 HTTP code$/) do
  expect(last_response.status).to eql(200)
end
