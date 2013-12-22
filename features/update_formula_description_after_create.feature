Feature: Update formula description after update
  In order to understand the purpose of a formula
  As a robot
  I want to update the formula description after update
  So that the visitors can read the description immediately

  Scenario: Create a new formula and check its description
    Given the Github homebrew repository has the new afuse formula with homepage "https://github.com/pcarrier/afuse/"
    And the Github homebrew repository has been cloned
    When the background task to get or update the formulae is executed
    Then the formula Afuse should have the following description:
    """
    An automounter implemented with FUSE
    """

  Scenario: Change the formula homepage and check its description
    Given following Homebrew formula exists:
      | filename    | afuse                                                 |
      | name        | Afuse                                                 |
      | homepage    | http://www.google.com                                 |
      | description | This is a manual description which need to be updated |
    Then the formula Afuse should have the following description:
    """
    This is a manual description which need to be updated
    """
    Given the Github homebrew repository has the afuse formula with homepage "https://github.com/pcarrier/afuse/"
    And the Github homebrew repository has been cloned
    When the background task to get or update the formulae is executed
    Then the formula Afuse should have the following description:
    """
    An automounter implemented with FUSE
    """
