Feature: Formula list
  In order to see all formulas
  As a user
  I want the entire list of existing formulas

  Background:
    Given it is currently 2 weeks ago
    And some formulas exist
    And I jump in our Delorean and return to the present

  Scenario: Looking at formula list without new imports of fomulas
    When I go to brewformulas.org
    Then I should see some formulas
    But I should see no inactive formulas
    And I should see no new formulas

  Scenario: Looking at formula list with a running import of fomulas
    Given an import is running
    When I go to brewformulas.org
    Then I should see some formulas
    But I should see no inactive formulas
    And I should see no new formulas

  Scenario: Looking at formula list with a finished import of fomulas on failure
    Given an import has finished on failure since more than a minute
    When I go to brewformulas.org
    Then I should see some formulas
    But I should see no inactive formulas
    And I should see no new formulas

  Scenario: Looking at formula list with a finished import of fomulas on success
    Given an import has finished on success since more than a minute
    And all formulas have been touched during the latest import
    When I go to brewformulas.org
    Then I should see some formulas
    But I should see no inactive formulas
    And I should see no new formulas

  Scenario: Looking at formula list with a finished import of fomulas on success with one formula not touched
    Given an import has finished on success since more than a minute
    And all formulas have been touched during the latest import excepted A52dec
    When I go to brewformulas.org
    Then I should see some formulas
    And I should see 1 inactive formula
    But I should see no new formulas

  Scenario: Looking at formula list with a finished import of fomulas on success with one new formula
    Given it is currently 15 minutes ago
    And an import has finished on success since more than a minute
    And all formulas have been touched during the latest import
    And the new "Cucumber" formula has been imported
    And I jump in our Delorean and return to the present
    When I go to brewformulas.org
    Then I should see some formulas
    And I should see no inactive formulas
    And I should see 1 new formula
