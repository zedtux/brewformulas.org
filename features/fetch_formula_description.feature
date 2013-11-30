Feature: Fetch formula description
  In order to understand what is the purpose of a formula
  As a robot
  I want to fetch it from the formula homepage
  So that it can be shown on brewformulas.org

  Scenario Outline: Fetch formula description from homepage
    Given following Homebrew formula exists:
      | name     | <name>     |
      | homepage | <homepage> |
    When the background task to fetch formula description runs
    Then the formula <name> should have the following description:
    """
    <description>
    """
  Examples:
    | name     | homepage         | description                                                                                                                                                                                                                                   |
    | A2ps     | http://a2ps/     | GNU a2ps is an Any to PostScript filter.                                                                                                                                                                                                      |
    | Abcl     | http://abcl/     | Armed Bear Common Lisp (ABCL) is a full implementation of the Common Lisp  language featuring both an interpreter and a compiler,  running in the JVM.                                                                                        |
    | Abook    | http://abook/    | Abook is a text-based addressbook program designed to use with mutt mail client.                                                                                                                                                              |
    | Ack      | http://ack/      | ack 2.10 is a tool like grep, optimized for programmers   Designed for programmers with large heterogeneous  trees of source code, ack is written purely in  portable Perl 5 and takes advantage of the power of  Perl's regular expressions. |
    | ACPICA   | http://acpica/   | The ACPI Component Architecture (ACPICA) project provides an operating system (OS)-independent reference implementation of the Advanced Configuration and Power Interface Specification (ACPI).                                               |
    | activemq | http://activemq/ | Apache ActiveMQ ™ is the most popular and powerful open source messaging and Integration Patterns server.                                                                                                                                     |

  Scenario: Try to fetch the description from an URL responding with a 404 error
    Given the Libgadu formula with homepage "http://toxygen.net/libgadu/" exists
    When the background task to fetch formula description runs
    Then the formula Libgadu should have the following description:
    """
    No description available
    """
