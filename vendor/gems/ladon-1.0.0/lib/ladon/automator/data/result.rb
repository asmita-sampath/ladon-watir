module Ladon
  module Automator
    # Represents the accumulated outcome data for an Automation.
    # Includes success/failure info, as well as any timing, log, and data_log information.
    #
    # @attr_reader [Ladon::Automator::Config] config The config used to instantiate the automation.
    # @attr_reader [Ladon::Automator::Logging::Logger] logger The logger and its log record for the automation.
    # @attr_reader [Ladon::Automator::Timing::Timer] timer The execution timer and time log for the automation.
    # @attr_reader [Hash<Object, Object>] data_log The arbitrary key:value data log associated with the automation.
    # @attr_reader [Symbol] status The symbol representing success/failure/error result
    class Result
      attr_reader :logger, :timer, :status, :data_log, :config

      SUCCESS_FLAG = :SUCCESS # Indicates that the Automation completed normally
      FAILURE_FLAG = :FAILURE # Indicates that the Automation failed as the result of some assertion
      ERROR_FLAG = :ERROR # Indicates that the Automation failed due to some unexpected error

      # Create a new Automator Result instance.
      #
      # @param [Ladon::Automator::Config] config The config that was given to the Automation this result belongs to.
      def initialize(config)
        @config = config
        @id = config.id
        @status = SUCCESS_FLAG # every Result is a success until something bad happens
        @logger = Ladon::Automator::Logging::Logger.new(level: config.log_level)
        @timer = Ladon::Automator::Timing::Timer.new
        @data_log = {}
      end

      # Record an arbitrary key:value pair in the +data_log+.
      #
      # @raise [ArgumentError] if key is not provided.
      #
      # @param [Object] key The key to use in the data log.
      # @param [Object] value The value to enter into the data log.
      # @return [Object] The value now contained in the data log at the given +key+.
      def record_data(key, value)
        raise ArgumentError, 'Key is required!' if key.nil?
        @data_log[key] = value
      end

      # Mark this run as having encountered a failure.
      # @return [Boolean] New status value.
      def failure
        @status = FAILURE_FLAG if @status == SUCCESS_FLAG
      end

      # Mark this Result as having encountered an error.
      # @return [Boolean] New status value.
      def error
        @status = ERROR_FLAG if @status == SUCCESS_FLAG
      end

      # Ask if the result is marked as a success.
      # @return [Boolean] True if result is a success; false otherwise.
      def success?
        @status == SUCCESS_FLAG
      end

      # Ask if the result is marked as a failure.
      # @return [Boolean] True if result is a failure; false otherwise.
      def failure?
        @status == FAILURE_FLAG
      end

      # Ask if the result is marked as an error.
      # @return [Boolean] True if result is a error; false otherwise.
      def error?
        @status == ERROR_FLAG
      end
    end
  end
end
