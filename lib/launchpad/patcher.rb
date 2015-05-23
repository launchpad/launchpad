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

    # Allows a callback to be provided that will run whenever progress is set.
    # @param [Proc] block
    # @return [self]
    def on_update(&block)
      @update_callback = block
      self
    end

    # @return [Float] the completion percentage for the current operation.
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
