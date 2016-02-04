require 'batali-tk'
require 'kitchen/provisioner'
require 'kitchen/provisioner/chef_base'
require 'kitchen/errors'
require 'kitchen/logging'

module Kitchen
  module Provisioner
    module Chef
      # Chef cookbook resolver using Batali to calculate dependencies
      class Batali

        include Logging

        class << self

          # Load Batali
          #
          # @param logger [Logger]
          def load!(logger=Kitchen.logger)
            begin
              require 'batali'
              require 'stringio'
            rescue LoadError => error
              logger.fatal("Failed to load the `batali` gem! (#{e.class}: #{e})")
              raise UserError.new "Failed to load the `batali` gem! (#{e.class}: #{e}"
            end
          end

        end

        # @return [Batali::BFile]
        attr_reader :batali_file
        # @return [String] path to vendor cookbooks
        attr_reader :vendor_path
        # @return [Logger]
        attr_reader :logger

        def initialize(b_file, path, logger=Kitchen.logger)
          @batali_file = b_file
          @vendor_path = path
          @logger = logger
        end

        # Resolve cookbooks and install into vendor location
        def resolve
          info "Resolving cookbook dependencies with Batali #{::Batali::VERSION}..."
          debug "Using Batali file located at: #{batali_file}"
          output = ''
          begin
            if(ENV['KITCHEN_BATALI_FILE'])
              debug 'Running Batali resolution in full vendor directory isolation'
              FileUtils.cp(
                batali_file,
                File.join(
                  File.dirname(vendor_path),
                  'Batali'
                )
              )
              Dir.chdir(File.dirname(vendor_path)) do
                ::Batali::Command::Update.new(
                  Smash.new(
                    :path => vendor_path,
                    :update => {
                      :install => true,
                      :environment => ENV['KITCHEN_BATALI_ENVIRONMENT'],
                      :infrastructure => false
                    },
                    :ui => Bogo::Ui.new(
                      :app_name => 'Batali',
                      :output_to => StringIO.new(output)
                    ),
                  ),
                  []
                ).execute!
              end
            else
              ::Batali::Command::Update.new(
                Smash.new(
                  :file => batali_file,
                  :path => vendor_path,
                  :update => {
                    :install => true,
                    :environment => ENV['KITCHEN_BATALI_ENVIRONMENT'],
                    :infrastructure => false
                  },
                  :ui => Bogo::Ui.new(
                    :app_name => 'Batali',
                    :output_to => StringIO.new(output)
                  ),
                ),
                []
              ).execute!
            end
          rescue => e
            error "Batali failed to install cookbooks! #{e.class}: #{e}"
            raise e
          end
          debug "Batali output:\n#{output}"
        end

      end

    end
  end
end
