module Launchpad
  # Options controller for updating settings
  class OptionsController
    include JRubyFX::Controller
    fxml 'options.fxml'

    # Triggered when the cancel button is pressed
    def cancel
      @stage.close
    end
  end
end
