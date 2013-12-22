require 'webmock'
include WebMock::API

fixture_root = File.join(Rails.root, 'features', 'fixtures', 'webmock')

{
  'http://www.gnu.org/software/a2ps/' => 'a2ps',
  'http://liba52.sourceforge.net/' => 'a52dec',
  'http://abcl.org' => 'abcl',
  'http://abook.sourceforge.net/' => 'abook',
  'http://beyondgrep.com/' => 'ack',
  'https://www.acpica.org/' => 'acpica',
  'http://activemq.apache.org/' => 'activemq',
  'http://adobe.com/products/air/sdk' => 'adobeairsdk',
  'https://github.com/pcarrier/afuse/' => 'afuse',
  'http://aircrack-ng.org/' => 'aircrackng',
  'http://www.gerd-neugebauer.de/software/TeX/BibTool/index.en.html' => 'bt',
  'http://www.monkeymental.com/' => 'cdpr',
  'http://www.celt-codec.org/' => 'celt',
  'http://www.bluem.net/jump/cliclick/' => 'cliclick',
  'http://llvm.org/' => 'llvm',
  'https://github.com/axkibe/lsyncd' => 'lsyncd',
  'http://www.foolabs.com/xpdf/' => 'xpdf',
  'https://code.google.com/p/zopfli/' => 'zopfli',
  'http://www.zsh.org/' => 'zsh'
}.each_pair do |url, folder|
  stub_request(:get, url)
    .to_return(
      status: 200,
      body: File.read(File.join(fixture_root, folder, 'index.html')))
end

stub_request(:get, 'http://toxygen.net/libgadu/')
  .to_return(status: [404, 'Not Found'])
