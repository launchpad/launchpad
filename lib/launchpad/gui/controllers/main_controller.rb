module Launchpad
  # Main application GUI controller
  class MainController
    include JRubyFX::Controller
    fxml 'main.fxml'

    # Triggered when the options button is pressed
    def show_options
      @options ||=
        stage title: 'Options',
              always_on_top: true,
              x: Application.main_stage.x + 20,
              y: Application.main_stage.y + 40

      @options.show
    end
  end
end
