Given(/^I send a GET request in JSON to the root url$/) do
  get '/', format: 'json'
end

Given(
  /^I send a GET request in JSON to the (.*?) formula url$/
) do |formula_name|
  formula_name = 'this-formula-doesnt-exist' if formula_name == 'not-existing'
  get "/#{formula_name}.json", formula: 'json'
end

Then(/^I should receive a 404 HTTP error code$/) do
  expect(last_response.status).to eql(404)
end

Then(/^I should receive a 200 HTTP code$/) do
  expect(last_response.status).to eql(200)
end

Then(/^the request body should be the following JSON:$/) do |expected|
  expect(JSON.parse(last_response.body)).to eql(JSON.parse(expected))
end
