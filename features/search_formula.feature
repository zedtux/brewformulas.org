Feature: Search formula
  In order to find a forumula
  As a user
  I want a search box
  So that I can find quickly a formula based on its name or keywords

  Background:
    Given it is currently monday morning
    And following Homebrew formulas exist:
      | filename | name   |
      | a2ps     | A2ps   |
      | a52dec   | A52dec |
      | bb-cp    | Bbcp   |
      | zzuf     | Zzuf   |

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
