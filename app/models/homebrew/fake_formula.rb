# Override the Homebrew Formula class
# in order to only read the interesting values
#
# @author [guillaumeh]
module Homebrew
  class FakeFormula
    class << self
      [
        :url,
        :mirror,
        :version,
        :homepage,
        :sha1,
        :conflicts_with,
        :depends_on,
        :head
      ].each do |attribute|
        self.class_eval <<-eos
          def #{attribute.to_s}(*value)
            return @#{attribute.to_s} unless value.first
            @#{attribute.to_s} = value.first
          end
        eos
      end

      def test; end
      def include?(value); false; end

      def method_missing(method, *args, &block)
        self
      end

      ENV.class.send(:define_method, :compiler){}
      String.send(:define_method, :undent){}
    end

  end
end

class MacOS
  class << self
    def version; :mavericks; end

    def method_missing(method, *args, &block)
      self
    end
  end
end

class DummyClass
  class << self
    def test; end
    def include?(*args); ""; end

    def method_missing(method, *args, &block)
      self
    end
  end
end
::AmazonWebServicesFormula = DummyClass
::CurlDownloadStrategy = DummyClass
::CurlUnsafeDownloadStrategy = DummyClass
::GitDownloadStrategy = DummyClass
::GithubGistFormula = DummyClass
::MacOS::CLT = DummyClass
::MacOS::Xcode = DummyClass
::MacOS::X11 = DummyClass
::MysqlDependency = DummyClass
::Requirement = DummyClass
::ScriptFileFormula = DummyClass
::StrictSubversionDownloadStrategy = DummyClass
::Tab = DummyClass
::UnsafeSubversionDownloadStrategy = DummyClass
::Version = DummyClass

HOMEBREW_PREFIX=""
