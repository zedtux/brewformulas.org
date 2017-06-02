Feature: Search formula
  In order to find a forumula
  As a user
  I want a search box
  So that I can find quickly a formula based on its name or keywords

  Background:
    Given it is currently monday morning
    And following Homebrew formulas exist:
      | filename | name   | description                                     |
      | a2ps     | A2ps   | GNU a2ps is an Any to PostScript filter.        |
      | a52dec   | A52dec | a free ATSC A/52 stream decoder                 |
      | bb-cp    | Bbcp   |                                                 |
      | zzuf     | Zzuf   | zzuf is a transparent application input fuzzer. |

  Scenario: Checks the checked search options by default
    When I go to brewformulas.org
    Then I should see the names, filenames and descriptions checkboxes checked

  Scenario: Search a formula by its name without a result
    When I go to brewformulas.org
    And I search a formula with "Vlc"
    Then I should not see any formula

  Scenario: Search a formula by its name with a result
    When I go to brewformulas.org
    And I search a formula with "2"
    Then I should see the A2ps and A52dec Homebrew formulas

  Scenario: Search a formula by its filename with a result
    When I go to brewformulas.org
    And I search a formula with "bb-cp"
    Then I should see the Bbcp Homebrew formula

  Scenario: Search only by names
    When I go to brewformulas.org
    And I uncheck "Filenames"
    And I uncheck "Descriptions"
    And I search a formula with "a"
    Then I should see the A2ps and A52dec Homebrew formulas

  Scenario: Search only by filenames
    When I go to brewformulas.org
    And I uncheck "Names"
    And I uncheck "Descriptions"
    And I search a formula with "-"
    Then I should see the Bbcp Homebrew formula

  Scenario: Search only by descriptions
    When I go to brewformulas.org
    And I uncheck "Names"
    And I uncheck "Filenames"
    And I search a formula with "transparent"
    Then I should see the Zzuf Homebrew formula
    When I search a formula with "is"
    Then I should see the A2ps and Zzuf Homebrew formulas
