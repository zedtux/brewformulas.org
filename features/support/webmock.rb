require "webmock"
include WebMock::API

fixture_root = File.join(Rails.root, "features", "fixtures", "webmock")

{
  "http://www.gnu.org/software/a2ps/" => "a2ps",
  "http://abcl.org" => "abcl",
  "http://abook.sourceforge.net/" => "abook",
  "http://beyondgrep.com/" => "ack",
  "https://www.acpica.org/" => "acpica",
  "http://activemq.apache.org/" => "activemq",
  "http://www.gerd-neugebauer.de/software/TeX/BibTool/index.en.html" => "bibtool",
  "http://adobe.com/products/air/sdk" => "adobeairsdk",
  "https://github.com/pcarrier/afuse/" => "afuse",
  "http://aircrack-ng.org/" => "aircrackng",
  "https://code.google.com/p/zopfli/" => "zopfli",
  "http://www.zsh.org/" => "zsh"
}.each_pair do |url, folder|
  stub_request(:get, url).
    to_return(
      :status => 200,
      :body => File.read(File.join(fixture_root, folder, "index.html")))
end

stub_request(:get, "http://toxygen.net/libgadu/").
  to_return(:status => [404, "Not Found"])
