module Launchpad
  # Updates installation directory with the required files.
  class Patcher
    # @return [Launchpad::Index] used to determine what needs updating.
    attr_reader :index

    def initialize
      @index = Index.new
    end

    # @return [Boolean] determines whether local and remote files are the same.
    def in_sync?
      index.diff.empty?
    end
  end
end
