require 'securerandom'

module Ladon
  module Automator
    # Facilitates configuration of +Ladon::Modeler::Graph+ instances.
    #
    # @attr_reader [Object] id The id associated with this config.
    # @attr_reader [Ladon::Automator::Logging::Level] log_level Log level to use for the Automation's Logger instance.
    # @attr_reader [Ladon::Flags] flags The flags to use to configure a Ladon model.
    class Config
      attr_reader :id, :log_level, :flags

      # Create a new Automator Config instance.
      #
      # @param [Object] id Some identifier used to track the Automation instance.
      # @param [Ladon::Automator::Logging::Level] log_level The log level to use for the Automation's Logger instance.
      # @param [Ladon::Flags|Hash] flags The Flags instance to use, or a Hash to use to build a Flags instance.
      def initialize(id: SecureRandom.uuid, log_level: nil, flags: nil)
        @id = id
        @flags = flags.is_a?(Ladon::Flags) ? flags : Ladon::Flags.new(in_hash: flags)
        @log_level = Automator::Logging::Level::ALL.include?(log_level) ? log_level : Automator::Logging::Level::ERROR
      end
    end
  end
end
