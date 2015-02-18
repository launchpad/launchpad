module Launchpad
  # Options controller for updating settings
  class OptionsController
    include JRubyFX::Controller
    fxml 'options.fxml'

    def cancel
      @stage.close
    end
  end
end
