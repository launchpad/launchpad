module Launchpad
  # Synchronizes the state of the patcher with the view
  class UpdateManager
    attr_reader :controller, :patcher

    def initialize(controller)
      @controller = controller
      @patcher = Patcher.new
    end

    def scan
      patcher.in_sync? ? ready_to_launch : ready_to_update
    end

    private

    def ready_to_launch
      controller.status.set_text 'Ready'
    end

    def ready_to_update
      controller.status.set_text 'Update required...'
    end
  end
end
