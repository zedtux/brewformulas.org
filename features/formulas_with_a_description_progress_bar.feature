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

  Scenario: Check the progress bar with 30 formulas and with 7 of then with a description
    Given 30 formulas exist
    And 7 formulas have a description
    When I go to brewformulas.org
    Then the formulas with a description coverage should be 23%

  Scenario: Check the progress bar with 30 formulas with 3 with a description
    Given 30 formulas exist
    And 10 formulas have a description
    When I go to brewformulas.org
    Then the formulas with a description coverage should be 33%
