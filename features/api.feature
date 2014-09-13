Feature: API
  In order to allow 3rd party application to communicate with me
  As an application
  I want to have an API responding in JSON
  So that requesting the URL of a formula with the JSON format return me a JSON

  Scenario: GET request in JSON to the root URL
    When I send a GET request in JSON to the root url
    Then I should receive a 415 HTTP error code

  Scenario: GET request in JSON to a missing formula URL
    Given on formulas exist
    When I send a GET request in JSON to the not-existing formula url
    Then I should receive a 404 HTTP error code

  Scenario: GET request in JSON to a formula URL
    Given the A52dec formula with homepage "http://liba52.sourceforge.net/" exists
    When I send a GET request in JSON to the a52dec formula url
    Then I should receive a 200 HTTP code
