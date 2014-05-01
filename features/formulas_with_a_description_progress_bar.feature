Feature: Formulas with a description progress bar
In order to have an overview of the remaining formulas without a description
As a user
I want a progress bar showing me the pourcentage of formulas with a description

  Scenario: Check the progress bar without formula
    When I go to brewformulas.org
    Then the formulas with a description coverage should be 0%

  Scenario: Check the progress bar with a formula without a description
    Given the Zsync formula with homepage "http://zsync.moria.org.uk/" exists
    When I go to brewformulas.org
    Then the formulas with a description coverage should be 0%

  Scenario: Check the progress bar with a formula with a description
    Given the Zsync formula with homepage "http://zsync.moria.org.uk/" exists
    And the Zsync formula has the description "This is a description"
    When I go to brewformulas.org
    Then the formulas with a description coverage should be 100%

  Scenario: Check the progress bar with 12 formulas with 2 with a description
    Given 12 formulas exist
    And 2 formulas has a description
    When I go to brewformulas.org
    Then the formulas with a description coverage should be 16%

  Scenario: Check the progress bar with 12 formulas with 3 with a description
    Given 12 formulas exist
    And 3 formulas has a description
    When I go to brewformulas.org
    Then the formulas with a description coverage should be 25%
