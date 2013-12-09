Feature: Show the formula name in the page title
  In order to see which formula is selected
  As a user
  I want to have the formula name in the title of the page
  So that when I use tabs in my web browser
  I can see directly which formula is selected in a specific tab

  Scenario: Check the page title when on the homepage
    When I go to brewformulas.org
    Then the page title should be "Homebrew Formulas"

  Scenario: Chech the page title when having selected a formula
    Given the A2ps formula with homepage "http://www.gnu.org/software/a2ps/" exists
    When I go to the formula A2ps on brewformulas.org
    Then the page title should be "Homebrew Formulas - A2ps"
