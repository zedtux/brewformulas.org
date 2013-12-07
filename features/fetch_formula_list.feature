Feature: Fetch formula list
  In order to show, search and look homebrew formulas
  As a robot
  I want to import the formulas from the Github repository
  So that I can update the database of available formulae

  Scenario: First execution should clone the repository
    Given no formula exist in homebrew
    And the Github homebrew repository is not clone yet
    And the Github homebrew repository has some formulae
    When the background task to get or update the formulae is executed
    Then the Github homebrew repository should be cloned
    And there should be some formulas in the database

  Scenario: Update existing repository without updates
    Given some formulas exist
    And the Github homebrew repository has been cloned
    And the Github homebrew repository doesn't have update
    When the background task to get or update the formulae is executed
    Then formulas should not been updated

  Scenario: Update existing repository with updated formula
    Given some formulas exist
    And the Github homebrew repository has been cloned
    And the Github homebrew repository has an updated formula
    When the background task to get or update the formulae is executed
    Then no new formula should be in the database
    And a formula should be updated

  Scenario: Update existing repository with a formula with multiple formula classes
    Given some formulas exist
    And the Github homebrew repository has been cloned
    And the Github homebrew repository has a formula having multiple formula classes
    When the background task to get or update the formulae is executed
    Then a new formula should be available in the database

  Scenario: Update existing repository with new formula
    Given some formulas exist
    And the Github homebrew repository has been cloned
    And the Github homebrew repository has a new formula
    When the background task to get or update the formulae is executed
    Then a new formula should be available in the database

  Scenario: Update existing repository with deleted formula
    Given it is currently yesterday 2 hours after midnight
    And some formulas exist
    And the Github homebrew repository has been cloned
    And the Github homebrew repository has an deleted formula
    And it is currently midnight
    When the background task to get or update the formulae is executed
    Then a formula should be flagged as deleted in the database
    When I go to brewformulas.org
    Then I should see some formulas
    But I should not see the Arm formula

  Scenario: Update existing repository with a formula including a backtick
    Given no formula exist in homebrew
    And the Github homebrew repository has a formula having backticks
    And the Github homebrew repository has been cloned
    When the background task to get or update the formulae is executed
    Then a new formula should be available in the database

  Scenario: Import a formula with dependencies
    Given no formula exist in homebrew
    And the Github homebrew repository has a formula with dependencies
    And the Github homebrew repository has been cloned
    When the background task to get or update the formulae is executed
    Then new formulas should be available in the database
    And some formulas should be linked as dependencies

  Scenario: Import a formula with a dependency not provided by Homebrew
    Given no formula exist in homebrew
    And the Github homebrew repository has a formula with an external dependency
    And the Github homebrew repository has been cloned
    When the background task to get or update the formulae is executed
    Then new formulas should be available in the database
    And a formula should be flagged as external dependency

  Scenario: Import a formula with conflicts including a reason
    Given no formula exist in homebrew
    And the Github homebrew repository has a formula with conflicts with a reason
    And the Github homebrew repository has been cloned
    When the background task to get or update the formulae is executed
    Then new formulas should be available in the database
    And some formulas should be linked as conflicts

  Scenario: Import a formula with conflicts including a reason with because issue
    Given no formula exist in homebrew
    And the Github homebrew repository has a formula with conflicts with a reason with because issue
    And the Github homebrew repository has been cloned
    When the background task to get or update the formulae is executed
    Then new formulas should be available in the database
    And some formulas should be linked as conflicts

  Scenario: Import a formula with conflicts including a reason on multiple lines
    Given no formula exist in homebrew
    And the Github homebrew repository has a formula with conflicts with a reason on multiple lines
    And the Github homebrew repository has been cloned
    When the background task to get or update the formulae is executed
    Then new formulas should be available in the database
    And some formulas should be linked as conflicts

  Scenario: Import a formula with conflicts excluding a reason
    Given no formula exist in homebrew
    And the Github homebrew repository has a formula with conflicts
    And the Github homebrew repository has been cloned
    When the background task to get or update the formulae is executed
    Then new formulas should be available in the database
    And some formulas should be linked as conflicts
