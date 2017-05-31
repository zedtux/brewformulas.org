Feature: Fetch formula version
  In order to know the current version of the formula
  As a robot
  I want to fetch the version from its URL or version tag
  So that it can be shown on brewformulas.org

  Scenario: Fetch the formula version from the formula `version` tag
    Given the A2fs formula file has the version attribute with the value "2.0.1"
    When the background task to get or update the formulae is executed
    Then the formula A2fs should have the version 2.0.1

  Scenario Outline: Fetch formula version from the formula `url` tag
    Given some formulas exist
    And the Github homebrew repository has been cloned
    And the <name> formula with the URL <url> exists
    When the background task to get or update the formulae is executed
    Then the formula <name> should have the version <expected-version>
  Examples:
    | name             | url                                                                                                                               | expected-version |
    | Ccextractor      | https://downloads.sourceforge.net/project/ccextractor/ccextractor/0.84/ccextractor.src.0.84.zip                                   | 0.84             |
    | Cdk              | ftp://invisible-island.net/cdk/cdk-5.0-20161210.tgz                                                                               | 5.0-20161210     |
    | Ceylon           | https://ceylon-lang.org/download/dist/1_3_2                                                                                       | 1.3.2            |
    | Cfr              | http://www.benf.org/other/cfr/cfr_0_121.jar                                                                                       | 0.121            |
    | Cimg             | http://cimg.eu/files/CImg_2.0.0.zip                                                                                               | 2.0.0            |
    | Clens            | https://github.com/conformal/clens/archive/CLENS_0_7_0.tar.gz                                                                     | 0.7.0            |
    | Clockywock       | https://soomka.com/clockywock-0.3.1a.tar.gz                                                                                       | 0.3.1a           |
    | ClosureCompiler  | https://search.maven.org/remotecontent?filepath=com/google/javascript/closure-compiler/v20170521/closure-compiler-v20170521.jar   | 20170521         |
    | Choose           | https://github.com/sdegutis/choose/archive/1.0.tar.gz                                                                             | 1.0              |
    | Distcc           | https://github.com/distcc/distcc/archive/v3.2rc1.tar.gz                                                                           | 3.2rc1           |
    | Ed               | https://ftp.gnu.org/gnu/ed/ed-1.14.2.tar.lz                                                                                       | 1.14.2           |
    | Einstein         | https://web.archive.org/web/20120621005109/games.flowix.com/files/einstein/einstein-2.0-src.tar.gz                                | 2.0              |
    | Eiffelstudio     | https://ftp.eiffel.com/pub/download/17.01/eiffelstudio-17.01.9.9700.tar                                                           | 17.01.9.9700     |
    | Ejabberd         | https://www.process-one.net/downloads/ejabberd/17.04/ejabberd-17.04.tgz                                                           | 17.04            |
    | Epstool          | http://pkgs.fedoraproject.org/repo/pkgs/epstool/epstool-3.08.tar.gz/465a57a598dbef411f4ecbfbd7d4c8d7/epstool-3.08.tar.gz          | 3.08             |
    | ERAlchemy        | https://files.pythonhosted.org/packages/f8/84/a7e4b73a427425e8d2d0446b6e94320e7ab4c44abe29c66150a7ee14f981/ERAlchemy-1.1.0.tar.gz | 1.1.0            |
    | Euca2ools        | https://downloads.eucalyptus.com/software/euca2ools/3.4/source/euca2ools-3.4.1.tar.xz                                             | 3.4.1            |
    | ExcelCompare     | https://github.com/na-ka-na/ExcelCompare/releases/download/0.6.1/ExcelCompare-0.6.1.zip                                           | 0.6.1            |
    | EyeD3            | http://eyed3.nicfit.net/releases/eyeD3-0.7.8.tar.gz                                                                               | 0.7.8            |
    | Faad2            | https://downloads.sourceforge.net/project/faac/faad2-src/faad2-2.7/faad2-2.7.tar.bz2                                              | 2.7              |
    | Fabio            | https://github.com/fabiolb/fabio/archive/v1.4.4.tar.gz                                                                            | 1.4.4            |
    | Libdwarf         | https://www.prevanders.net/libdwarf-20161124.tar.gz                                                                               | 20161124         |
    | Synfig           | https://downloads.sourceforge.net/project/synfig/releases/1.0.2/source/ETL-0.04.19.tar.gz                                         | 0.04.19          |

  Scenario: Fetch the formula version from the formula `url` tag with a `tag` key
    Given the Ipfs formula file has the url attribute with the tag key value "v0.4.9"
    When the background task to get or update the formulae is executed
    Then the formula Ipfs should have the version 0.4.9
