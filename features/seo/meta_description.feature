@seo
Feature: Meta description
  In order to improve the visibility of Brewformulas.org on search engines
  As a crawler
  I want to have the meta tag "description" filled in
  So that it will be re-used in the search engine results

  Scenario: Check the meta description on the homepage
    When I go to brewformulas.org
    Then the meta description tag should be "Homebrew (The missing package manager for OS X) formula list to search and discover new formulas"

  Scenario: Chech the meta description on a formula show page without a description
    Given the A2ps formula with homepage "http://www.gnu.org/software/a2ps/" exists
    When I go to the formula A2ps on brewformulas.org
    Then the meta description tag should be "Homebrew (The missing package manager for OS X) formula list to search and discover new formulas"

  Scenario: Chech the meta description on a formula show page with a description
    Given the A2ps formula with homepage "http://www.gnu.org/software/a2ps/" exists
    And the A2ps formula has the description "GNU a2ps is an Any to PostScript filter. Of course it processes plain text files, but also pretty prints quite a few popular languages."
    When I go to the formula A2ps on brewformulas.org
    Then the meta description tag should be "GNU a2ps is an Any to PostScript filter. Of course it processes plain text files, but also pretty prints quite a few popular languages."

  Scenario: Chech the meta description on a formula show page with a description longer than 160 characters
    Given the A2ps formula with homepage "http://www.gnu.org/software/a2ps/" exists
    And the A2ps formula has the description "GNU a2ps is an Any to PostScript filter. Of course it processes plain text files, but also pretty prints quite a few popular languages."
    When I go to the formula A2ps on brewformulas.org
    Then the meta description tag should be "GNU a2ps is an Any to PostScript filter. Of course it processes plain text files, but also pretty prints quite a few popular languages."

  Scenario: Chech the meta description on a formula show page with a description longer than 160 characters
    Given the Aamath formula with homepage "http://fuse.superglue.se/aamath/" exists
    And the Aamath formula has the description "aamath is a program that reads mathematical expressions in infix notation and renders them as ASCII art. It may be useful to send mathematics through text-only media, such as e-mail or newsgroups."
    When I go to the formula Aamath on brewformulas.org
    Then the meta description tag should be "aamath is a program that reads mathematical expressions in infix notation and renders them as ASCII art. It may be useful to send mathematics through text-on..."
