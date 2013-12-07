Feature: Formula conflicts
  In order to not to install a conflicting formula
  As a user
  I want to see the conflicting formulas

  Scenario: Look at a formula with no conflicts
    Given the Zsync formula with homepage "http://zsync.moria.org.uk/" exists
    When I go to the formula Zsync on brewformulas.org
    Then I should see no conflicts

  Scenario: Look at a formula with one conflict
    Given following Homebrew formulas exist:
      | name  | homepage                |
      | AvroC | http://avro.apache.org/ |
      | Xz    | http://tukaani.org/xz/  |
    And the formula AvroC is in conflict with Xz
    When I go to the formula AvroC on brewformulas.org
    Then I should see a conflict with Xz

  Scenario: Look at a formula with 2 conflicts
    Given following Homebrew formulas exist:
      | name      | homepage                            |
      | Xpdf      | http://www.foolabs.com/xpdf/        |
      | pdf2image | http://code.google.com/p/pdf2image/ |
      | poppler   | http://poppler.freedesktop.org      |
    And the formula Xpdf is in conflict with pdf2image and poppler
    When I go to the formula Xpdf on brewformulas.org
    Then I should see a conflict with pdf2image and poppler
