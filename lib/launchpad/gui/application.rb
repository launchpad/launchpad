require 'jrubyfx'

module Launchpad
  # Main application which is only created once at launch.
  class Application < JRubyFX::Application
    class << self
      # @return [Java::JavafxStage::Stage] the main stage.
      attr_accessor :main_stage
    end

    fxml_root 'lib/launchpad/gui/fxml'

    # Automatically called on Application.launch
    # @param [Java::JavafxStage::Stage] stage
    #   automatically provided when .launch is called.
    def start(stage)
      self.class.main_stage = stage

      with(stage, title: 'Launchpad', resizable: false) do
        fxml MainController
        show
      end
    end
  end
end
