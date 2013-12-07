Feature: Formula list
  In order to see all formulas
  As a user
  I want the entire list of existing formulas

  Background:
    Given some formulas exist
    And it is currently tomorrow

  Scenario: Looking at formula list without new imports of fomulas
    When I go to brewformulas.org
    Then I should see some formulas

  Scenario: Looking at formula list with a running import of fomulas
    Given an import is running
    When I go to brewformulas.org
    Then I should see some formulas

  Scenario: Looking at formula list with a finished import of fomulas on failure
    Given an import has finished on failure since more than a minute
    When I go to brewformulas.org
    Then I should see some formulas

  Scenario: Looking at formula list with a finished import of fomulas on success
    Given an import has finished on success since more than a minute
    And all formulas have been touched during the latest import
    When I go to brewformulas.org
    Then I should see some formulas

  Scenario: Looking at formula list with a finished import of fomulas on success with one formula not touched
    Given an import has finished on success since more than a minute
    And all formulas have been touched during the latest import excepted A52dec
    When I go to brewformulas.org
    Then I should see some formulas
