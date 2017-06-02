Feature: Formula dependencies
  In order to know the dependencies of a forumula
  As a user
  I want to see the formula dependences
  So that I know what will be installed on my machine

  Scenario: Look at a formula without any dependency
    Given the Zsync formula with homepage "http://zsync.moria.org.uk/" exists
    When I go to the formula Zsync on brewformulas.org
    Then I should see no dependencies

  Scenario: Look at a formula with one dependency
    Given following Homebrew formulas exist:
      | name  | homepage                                   |
      | Lrzsz | http://www.ohse.de/uwe/software/lrzsz.html |
      | Zssh  | http://zssh.sourceforge.net/               |
    And the formula Lrzsz is a dependency of Zssh
    When I go to the formula Zssh on brewformulas.org
    Then I should see Lrzsz as a dependency

  Scenario: Look at a formula with multiple dependencies
    Given following Homebrew formulas exist:
      | name    | homepage                          |
      | Daq     | http://www.snort.org/             |
      | Libdnet | http://code.google.com/p/libdnet/ |
      | Pcre    | http://www.pcre.org/              |
      | Snort   | http://www.snort.org              |
    And the formulas Daq, Libdnet, and Pcre are dependencies of Snort
    When I go to the formula Snort on brewformulas.org
    Then I should see Daq, Libdnet and Pcre as dependencies

  Scenario: Look at a formula which is a dependency for another formula
    Given following Homebrew formulas exist:
      | name  | homepage                                   |
      | Lrzsz | http://www.ohse.de/uwe/software/lrzsz.html |
      | Zssh  | http://zssh.sourceforge.net/               |
    And the formula Lrzsz is a dependency of Zssh
    When I go to the formula Lrzsz on brewformulas.org
    Then I should see no dependencies
    But I should see Zssh as dependent

  Scenario: Look at a formula which is a dependency for 2 formulas
    Given following Homebrew formulas exist:
      | name    | homepage                          |
      | Daq     | http://www.snort.org/             |
      | Libdnet | http://code.google.com/p/libdnet/ |
      | Snort   | http://www.snort.org              |
    And the formulas Daq and Libdnet are dependents of Snort
    When I go to the formula Snort on brewformulas.org
    Then I should see Daq and Libdnet as dependents

  Scenario: Look at a formula which is a dependency for 3 formulas
    Given following Homebrew formulas exist:
      | name    | homepage                          |
      | Daq     | http://www.snort.org/             |
      | Libdnet | http://code.google.com/p/libdnet/ |
      | Pcre    | http://www.pcre.org/              |
      | Snort   | http://www.snort.org              |
    And the formulas Daq, Libdnet, and Pcre are dependents of Snort
    When I go to the formula Snort on brewformulas.org
    Then I should see Daq, Libdnet and Pcre as dependents

  Scenario: Look at a formula which is a dependency for 4 formulas
    Given following Homebrew formulas exist:
      | name       | homepage                          |
      | Daq        | http://www.snort.org/             |
      | Libdnet    | http://code.google.com/p/libdnet/ |
      | Pcre       | http://www.pcre.org/              |
      | Pkg-config | http://pkgconfig.freedesktop.org/ |
      | Snort      | http://www.snort.org              |
    And the formulas Daq, Libdnet, Pcre, and Pkg-config are dependents of Snort
    When I go to the formula Snort on brewformulas.org
    Then I should see Daq, Libdnet, Pcre and 1 other formulas as dependents

  Scenario: Look at a dependency which is not provided by Homebrew
    Given the Cliclick formula with homepage "http://www.bluem.net/jump/cliclick/" exists
    And the Cliclick formula has Xcode as external dependency
    When I go to the formula Cliclick on brewformulas.org
    Then I should see Xcode as dependency
    When I click the Xcode formula name
    And I not should see the installation instruction
