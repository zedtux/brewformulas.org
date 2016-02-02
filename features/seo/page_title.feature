@seo
Feature: Page title
  In order to improve the visibility of Brewformulas.org on search engines
  As a crawler
  I want to have the formula name in the title of the page
  So that it will be re-used in the search engine results

  Scenario: Check the page title when on the homepage
    When I go to brewformulas.org
    Then the page title should be "Formula list — BrewFormulas"

  Scenario: Chech the page title when having selected a formula
    Given the A2ps formula with homepage "http://www.gnu.org/software/a2ps/" exists
    When I go to the formula A2ps on brewformulas.org
    Then the page title should be "A2ps — BrewFormulas"
