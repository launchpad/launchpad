module Launchpad
  # Options controller for updating settings
  class OptionsController
    include JRubyFX::Controller
    fxml 'options.fxml'

    OPTIONS = [
      :install,
      :local_index_path,
      :remote_index_uri,
      :login_server,
      :port
    ]

    OPTIONS.each do |option|
      attr_reader option
    end

    def initialize
      super
      @stage.on_shown { display_values }
    end

    # Saves any changes to settings and closes the stage.
    # Triggered when the cancel button is pressed.
    def accept
      save
      @stage.close
    end

    # Aborts all changes and closes the stage.
    # Triggered when the cancel button is pressed.
    def cancel
      @stage.close
    end

    # Loads all saved settings to the UI text fields.
    def display_values
      options.each do |option|
        update_ui option, read(option)
      end
    end

    private

    def options
      OPTIONS
    end

    def save
      options.each do |option|
        update option, read_ui(option)
      end
      Settings.save
    end

    def read_ui(option)
      send(option).get_characters.to_s
    end

    def update_ui(option, value)
      send(option).set_text value
    end

    def read(option)
      Settings.read option
    end

    def update(option, value)
      Settings.update option, value
    end
  end
end
