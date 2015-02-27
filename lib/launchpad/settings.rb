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

    # @return [Hash] hash of all saved settings loaded from yaml.
    attr_reader :settings

    def initialize
      @settings = YAML.load_file PATH
    end

    # @param option [Symbol] the attribute to be accessed from settings.
    # @return [String] the value associated with the provided attribute.
    def read(option)
      settings[option.to_s].to_s
    end
  end
end
