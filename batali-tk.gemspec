$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__)) + '/lib/'
require 'batali-tk/version'
Gem::Specification.new do |s|
  s.name = 'batali-tk'
  s.version = BataliTk::VERSION.version
  s.summary = 'Batali for test-kitchen'
  s.author = 'Chris Roberts'
  s.email = 'code@chrisroberts.org'
  s.homepage = 'https://github.com/hw-labs/batali-tk'
  s.description = 'Batali support injector for test kitchen'
  s.require_path = 'lib'
  s.license = 'Apache 2.0'
  s.add_runtime_dependency 'batali'
  s.add_runtime_dependency 'test-kitchen', BataliTk::TK_CONSTRAINT
  s.executables << 'batali-tk'
  s.files = Dir['{lib,bin}/**/**/*'] + %w(batali-tk.gemspec README.md CHANGELOG.md CONTRIBUTING.md LICENSE)
end
