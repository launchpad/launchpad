require 'singleton'
require 'forwardable'
require 'yaml'

module Launchpad
  # Provides default settings and allows user customization through creation of
  # a yaml file for overrides.
  class Settings
    include Singleton
    extend SingleForwardable

    # The path to the yaml file where settings are saved.
    PATH = 'config/settings.yml'

    def_delegators :instance, :read, :update, :save

    attr_reader :settings

    def initialize
      @settings = YAML.load_file PATH
    end

    # @param [Symbol] option
    #   the attribute to be read from saved settings.
    def read(option)
      settings[option.to_s].to_s
    end
  end
end
