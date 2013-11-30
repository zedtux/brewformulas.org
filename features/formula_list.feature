Feature: Formula list
  In order to see all formulae
  As a user
  I want the entire list of existing formulas

  Background:
    Given it is currently the afternoon
    And some formulas exist
    And I jump in our Delorean and return to the present

  Scenario: Listing the formulas 2 hours before midnight
    Given it is currently 2 hours before midnight
    When I go to brewformulas.org
    Then I should see some formulas

  Scenario: Listing the formulas 1 hour before midnight
    Given it is currently 1 hours before midnight
    When I go to brewformulas.org
    Then I should see some formulas

  Scenario: Listing the formulas at midnight
    Given it is currently midnight
    When I go to brewformulas.org
    Then I should see some formulas

  Scenario: Listing the formulas 1 hour after midnight
    Given it is currently 1 hours after midnight
    When I go to brewformulas.org
    Then I should not see any formula
    Given the Github homebrew repository has been cloned
    When the background task to get or update the formulae is executed
    And I go to brewformulas.org
    Then I should see some formulas
