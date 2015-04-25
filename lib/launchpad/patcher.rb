module Launchpad
  # Updates installation directory with the required files
  class Patcher
    attr_reader :index

    def initialize
      @index = Index.new
    end

    def in_sync?
      index.diff.empty?
    end
  end
end
