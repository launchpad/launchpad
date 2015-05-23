module Launchpad
  # Main application GUI controller.
  class MainController
    include JRubyFX::Controller
    fxml 'main.fxml'

    # @return [Launchpad::Patcher] manages syncing local and remote files
    attr_reader :patcher

    # @return [Java::JavafxSceneControl::ProgressBar]
    #   for updating the progress bar in the ui
    attr_reader :progress

    # @return [Java::JavafxSceneControl::Label]
    #   for displaying status to the ui
    attr_reader :status

    def initialize
      super

      @patcher = Patcher.new
      @patcher.on_update { update_progress }

      @stage.on_shown { scan }
    end

    # Compares local and remote files and updates the UI accordingly.
    def scan
      Thread.new do
        patcher.in_sync? ? ready_to_launch : ready_to_update
      end
    end

    # Triggered when the options button is pressed.
    def show_options
      @options ||=
        stage title: 'Options',
              fxml: OptionsController,
              always_on_top: true,
              resizable: false,
              x: Application.main_stage.x + 20,
              y: Application.main_stage.y + 40

      @options.show
    end

    # Update the UI with the patcher's current progress.
    def update_progress
      Platform.run_later do
        progress.set_progress patcher.progress
      end
    end

    private

    def ready_to_launch
      Platform.run_later do
        status.set_text 'Ready'
      end
    end

    def ready_to_update
      Platform.run_later do
        status.set_text 'Update required...'
      end
    end
  end
end
