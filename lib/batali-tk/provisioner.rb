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
          debug "Using Batail file located at: #{batali_file}"
          output = ''
          begin
            res = ::Batali::Command::Update.new(
              Smash.new(
                :file => batali_file,
                :path => vendor_path,
                :ui => Bogo::Ui.new(
                  :app_name => 'Batali',
                  :output_to => StringIO.new(output)
                ),
              ),
              []
            ).execute!
            debug output
            res
          rescue => e
            error "Batali failed to install cookbooks! #{e.class}: #{e}"
            debug output
          end
        end

      end

    end
  end
end
