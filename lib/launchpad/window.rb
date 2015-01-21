require 'jrubyfx'

# Main application window which is only created once at launch
class Window < JRubyFX::Application
  # Automatically called on {.launch}
  def start(stage)
    stage.title = 'Launchpad'
    stage.width = 800
    stage.height = 600
    stage.show
  end
end
