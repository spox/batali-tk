require 'batali-tk/version'

tk_spec = Gem::Specification.find_by_name('test-kitchen', BataliTk::TK_CONSTRAINT)
unless(tk_spec)
  raise LoadError.new "Failed to locate acceptable test-kitchen version. (Constraint: #{BataliTk::TK_CONSTRAINT}"
end

tk_spec.activate_dependencies
tk_spec.activate

require File.join(tk_spec.full_gem_path, 'lib/kitchen.rb')
require 'batali-tk'
