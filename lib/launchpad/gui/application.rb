require 'jrubyfx'

module Launchpad
  # Main application which is only created once at launch.
  class Application < JRubyFX::Application
    # Automatically called on {Application.launch}
    # @param [Java::JavafxStage::Stage] stage
    #   automatically provided when {.launch} is called.
    def start(stage)
      stage.title = 'Launchpad'
      stage.width = 800
      stage.height = 600
      stage.show
    end
  end
end
