require 'jrubyfx'

module Launchpad
  # Main application which is only created once at launch.
  class Application < JRubyFX::Application
    fxml_root 'lib/launchpad/gui/fxml'

    # Automatically called on {Application.launch}
    # @param [Java::JavafxStage::Stage] stage
    #   automatically provided when {.launch} is called.
    def start(stage)
      with(stage, title: 'Launchpad', resizable: false) do
        fxml MainController
        show
      end
    end
  end
end
