require 'digest'
require 'pathname'
require 'open-uri'

module Launchpad
  # Provides a diff between local and remote file data by maintaining a cache
  # with pathnames and md5 hex digests.
  class Index
    def initialize(patcher)
      @patcher = patcher
      @target_dir = Pathname.new Settings.read :install
      @local_index_path = Settings.read :local_index_path
      @remote_index_uri = Settings.read :remote_index_uri
    end

    # @return [Array<String>]
    #   an array of files that are not present or do not match the remote.
    def diff
      (remote - local).map(&:first)
    end

    # @return [Array<Array<Pathname, String>>]
    #   an array of pathnames and their md5 digests for the local install.
    def local
      @local ||= sort File.open(@local_index_path, 'r') { |file| parse file }
    rescue Errno::ENOENT
      []
    end

    # @return [Array<Array<Pathname, String>>]
    #   an array of remote pathnames and their md5 digests from the patcher.
    def remote
      @remote ||= sort Kernel.open(@remote_index_uri) { |file| parse file }
    rescue Errno::ENOENT
      []
    end

    # Updates {#local} with a full scan of the installation directory.
    # @return [self]
    def scan
      reset_local

      Pathname.glob(@target_dir + '**/*').select(&:file?).tap do |files|
        files.each_with_index do |pathname, index|
          append_record pathname, index, files.size
        end
      end

      save
    end

    private

    def append_record(pathname, index, size)
      return unless pathname.file?

      @local << [pathname.to_s, Digest::MD5.file(pathname).to_s]
      @patcher.progress = (index.to_f + 1) / size
    end

    def parse(file)
      file.read.split("\n").map do |line|
        line.split(' | ').tap do |path, md5|
          [Pathname.new(path), md5.chomp]
        end
      end
    end

    def reset_local
      @local = []
    end

    def save
      @local = sort local

      file = File.open(@local_index_path, 'w')

      local.each do |data|
        file.write "#{data[0]} | #{data[1]}\n"
      end

      file.close
      self
    end

    def sort(list)
      list.empty? ? list : list.sort_by(&:first)
    end
  end
end
