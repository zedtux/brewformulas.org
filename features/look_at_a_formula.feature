Feature: Look at a formula
  In order to discover a formula
  As a user
  I want show page with all the details about a formula
  So that I can determine if I need it or not

  Background:
    Given it is currently monday morning
    And the A2ps formula with homepage "http://www.gnu.org/software/a2ps/" exists

  Scenario: Having a look to a formula show page without a description
    When I go to the formula A2ps on brewformulas.org
    Then I should see "No description available. You can request to update it by clicking this link."
    When I request to update the formula description
    Then I should see the success alert "Your request has been successfully submitted."
    And I should see "GNU a2ps is an Any to PostScript filter."
    And I should see the following formula details:
      | Homepage | http://www.gnu.org/software/a2ps/ |
      | Version  | Unavailable                       |
    And I should see the installation instruction "brew install a2ps"

  Scenario: Having a look to a formula show page with a description automatically extracted from the homepage
    Given the automatically extracted description for the A2ps formula is "GNU a2ps is an Any to PostScript filter."
    When I go to the formula A2ps on brewformulas.org
    Then I should see the A2ps formula description automatically extracted from the homepage

  Scenario: Having a look to a formula show page with a description manually saved
    Given the A2ps formula has the description "GNU a2ps is an Any to PostScript filter."
    When I go to the formula A2ps on brewformulas.org
    Then I should see "GNU a2ps is an Any to PostScript filter."

  Scenario: Trying to access a formula which doesn't exists
    When I go to the formula Rocksmith on brewformulas.org
    Then I should see the error alert "This formula doesn't exists" on the homepage
