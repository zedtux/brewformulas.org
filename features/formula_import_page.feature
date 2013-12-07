Feature: Formula import page
  In order to look at the history of imports
  As a user
  I want a page with the list of imports
  So that I can see if an import ends on success or failure

  Scenario: Looking at the imports page without imports
    When I go to the imports on brewformulas.org
    Then I should see there is no imports

  Scenario: Looking at the imports page with a running import since 10 seconds
    Given an import is running
    And it is currently in 10 seconds
    When I go to the imports on brewformulas.org
    Then I should see a running import since less than 20 seconds

  Scenario: Looking at the imports page with a finished on success since less than a minute
    Given an import has finished on success since less than a minute
    When I go to the imports on brewformulas.org
    Then I should see a finished import with success since less than a minute

  Scenario: Looking at the imports page with a finished on failure since more than a minute
    Given an import has finished on failure since more than a minute
    When I go to the imports on brewformulas.org
    Then I should see a finished import with failure since 1 minute
