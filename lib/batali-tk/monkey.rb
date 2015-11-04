# Lets hook in batali support!
module BataliTk
  module Box

    def batali_file
      ENV.fetch('KITCHEN_BATALI_FILE', File.join(config[:kitchen_root], "Batali"))
    end

    def batali_prepare_cookbooks
      if(File.exists?(batali_file))
        resolve_with_batali
        filter_only_cookbook_files
      else
        tk_prepare_cookbooks
      end
    end

    def resolve_with_batali
      Kitchen.mutex.synchronize do
        Kitchen::Provisioner::Chef::Batali.new(batali_file, tmpbooks_dir, logger).resolve
      end
    end

    class << self

      def included(klass)
        klass.class_eval do
          alias_method :tk_prepare_cookbooks, :prepare_cookbooks
          alias_method :prepare_cookbooks, :batali_prepare_cookbooks
        end
      end

    end

  end

  module Base

    def batali_file
      ENV.fetch('KITCHEN_BATALI_FILE', File.join(config[:kitchen_root], "Batali"))
    end

    def batali_load_needed_dependencies!
      if(File.exists?(batali_file))
        debug "Batali file found at #{batali_file}, loading Batali"
        Kitchen::Provisioner::Chef::Batali.load!(logger)
      else
        tk_load_needed_dependencies!
      end
    end

    class << self

      def included(klass)
        klass.class_eval do
          alias_method :tk_load_needed_dependencies!, :load_needed_dependencies!
          alias_method :load_needed_dependencies!, :batali_load_needed_dependencies!
        end
      end

    end

  end
end

require 'kitchen/provisioner/base'
require 'kitchen/provisioner/chef_base'

begin
  require 'kitchen/provisioner/chef/common_sandbox'

  class Kitchen::Provisioner::ChefBase
    include BataliTk::Base
  end

  class Kitchen::Provisioner::Chef::CommonSandbox
    include BataliTk::Box
  end
rescue LoadError

  class Kitchen::Provisioner::ChefBase
    include BataliTk::Base
    include BataliTk::Box
  end

end
