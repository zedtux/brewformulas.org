Feature: API
  In order to allow 3rd party application to communicate with me
  As an application
  I want to have an API responding in JSON
  So that requesting the URL of a formula with the JSON format return me a JSON

  Scenario: GET request in JSON to the root URL
    When I send a GET request in JSON to the root url
    Then I should receive a 200 HTTP code

  Scenario: GET request in JSON to a missing formula URL
    Given on formulas exist
    When I send a GET request in JSON to the not-existing formula url
    Then I should receive a 404 HTTP error code

  Scenario: GET request in JSON to a formula URL
    Given following Homebrew formulas exist:
      | name           | homepage                          |
      | A52dec         | http://liba52.sourceforge.net/    |
      | GstPluginsUgly | http://code.google.com/p/libdnet/ |
      | GPac           | http://www.pcre.org/              |
    And the automatically extracted description for the A52dec formula is "a52dec is a test program for liba52."
    And the formula A52dec is a dependency of GPac
    And the formula A52dec is a dependency of GstPluginsUgly
    When I send a GET request in JSON to the a52dec formula url
    Then I should receive a 200 HTTP code
    And the request body should be the following JSON:
    """
    {
      "formula": "a52dec",
      "description": "a52dec is a test program for liba52.",
      "reference": "Extracted automatically from A52dec homepage",
      "homepage": "http://liba52.sourceforge.net/",
      "version": "",
      "dependencies": [
      ],
      "dependents": [
        "GPac",
        "GstPluginsUgly"
      ]
    }
    """

  Scenario: GET request in JSON to a formula URL with both dependencies and dependents
    Given following Homebrew formulas exist:
      | name  | homepage                          |
      | Zsh   | http://www.zsh.org/               |
      | Pcre  | http://www.pcre.org/              |
      | Gdbm  | http://www.gnu.org/software/gdbm/ |
      | Zshdb | https://github.com/rocky/zshdb    |
    And the Zsh formula has the description "Zsh is a shell designed for interactive use, although it is also a powerful scripting language."
    And the formula Zsh is a dependency of Zshdb
    And the formulas Pcre, and Gdbm are dependencies of Zsh
    When I send a GET request in JSON to the zsh formula url
    Then I should receive a 200 HTTP code
    And the request body should be the following JSON:
    """
    {
      "formula": "zsh",
      "description": "Zsh is a shell designed for interactive use, although it is also a powerful scripting language.",
      "reference": "",
      "homepage": "http://www.zsh.org/",
      "version": "",
      "dependencies": [
        "Gdbm",
        "Pcre"
      ],
      "dependents": [
        "Zshdb"
      ]
    }
    """
