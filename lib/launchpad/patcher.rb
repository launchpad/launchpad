module Launchpad
  # Updates installation directory with the required files.
  class Patcher
    # @return [Launchpad::Index] used to determine what needs updating.
    attr_reader :index

    def initialize
      @index = Index.new self
    end

    # @return [Boolean] determines whether local and remote files are the same.
    def in_sync?
      index.scan
      index.diff.empty?
    end

    # Determines the code to be executed when progress changes for the current
    # operation.
    def on_update(&block)
      @update_callback = block
    end

    # @return [Float]
    #   denotes the completion percentage for the current operation.
    def progress
      @progress || 0.0
    end

    # @param [Float] percentage
    #   sets the completion percentage for the current operation.
    def progress=(percentage)
      @progress = percentage
      @update_callback.call
    end
  end
end
