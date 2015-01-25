module Launchpad
  # Provides default settings and allows user customization through creation of
  # a yaml file for overrides.
  class Settings
    DEFAULT = {
      local_index_path: 'index',
      remote_index_uri: 'http://patcher.cuemu.com/index'
    }

    class << self
      DEFAULT.each_key do |key|
        define_method(key) do
          DEFAULT[key]
        end
      end
    end
  end
end
