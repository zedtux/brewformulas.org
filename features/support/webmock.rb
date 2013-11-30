require "webmock"
include WebMock::API

fixture_root = File.join(Rails.root, "features", "fixtures", "webmock")

stub_request(:get, "http://a2ps/").
  to_return(
    :status => 200,
    :body => File.read(File.join(fixture_root, "a2ps", "index.html")))
stub_request(:get, "http://ack/").
  to_return(
    :status => 200,
    :body => File.read(File.join(fixture_root, "ack", "index.html")))
stub_request(:get, "http://abcl/").
  to_return(
    :status => 200,
    :body => File.read(File.join(fixture_root, "abcl", "index.html")))
stub_request(:get, "http://abook/").
  to_return(
    :status => 200,
    :body => File.read(File.join(fixture_root, "abook", "index.html")))
stub_request(:get, "http://acpica/").
  to_return(
    :status => 200,
    :body => File.read(File.join(fixture_root, "acpica", "index.html")))
stub_request(:get, "http://activemq/").
  to_return(
    :status => 200,
    :body => File.read(File.join(fixture_root, "activemq", "index.html")))
stub_request(:get, "http://bibtool/").
  to_return(
    :status => 200,
    :body => File.read(File.join(fixture_root, "bibtool", "index.html")))
stub_request(:get, "http://toxygen.net/libgadu/").
  to_return(:status => [404, "Not Found"])
