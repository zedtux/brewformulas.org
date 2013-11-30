Feature: Look at a formula
  In order to discover a formula
  As a user
  I want show page with all the details about a formula
  So that I can determine if I need it or not

  Background:
    Given following Homebrew formulas exist:
      | name   |
      | A2ps   |

  Scenario: Having a look to a formula show page without a description
    When I go to brewformulas.org
    And I click the formula "A2ps"
    Then I should see "No description available. You can request to update it by clicking this link."

  Scenario: Having a look to a formula show page with a description automatically extracted from the homepage
    Given the automatically extracted description for the A2ps formula is "GNU a2ps is an Any to PostScript filter."
    When I go to brewformulas.org
    And I click the formula "A2ps"
    Then I should see the A2ps formula description automatically extracted from the homepage

  Scenario: Having a look to a formula show page with a description manually saved
    Given the A2ps formula has the description "GNU a2ps is an Any to PostScript filter."
    When I go to brewformulas.org
    And I click the formula "A2ps"
    Then I should see "GNU a2ps is an Any to PostScript filter."

  Scenario: Trying to access a formula which doesn't exists
    When I go to the formula Rocksmith on brewformulas.org
    Then I should see the error alert "This formula doesn't exists" on the homepage
