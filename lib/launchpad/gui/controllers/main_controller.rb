module Launchpad
  # Main application GUI controller
  class MainController
    include JRubyFX::Controller
    fxml 'main.fxml'

    # Triggered when the options button is pressed
    def show_options
      @options ||= stage title: 'Options'
      @options.on_close_request { @options = nil }
      @options.show
    end
  end
end
