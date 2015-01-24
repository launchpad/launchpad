require 'digest'
require 'open-uri'

module Launchpad
  # Provides a diff between local and remote file data by maintaining a cache
  # with pathnames and md5 hex digests.
  class Index
    # @param [Hash] options
    # @option options [String] :installation_path root installation directory.
    # @option options [String] :local_index_path where the local index is saved.
    # @option options [String] :remote_index_uri uri for the remote index.
    def initialize(options = {})
      @target_dir = Pathname.new options[:target_dir]
      @local_index_path = options[:local_index_path]
      @remote_index_uri = options[:remote_index_uri]
    end

    # @return [Array<String>]
    #   an array of files that are not present or do not match the remote.
    def diff
      (remote - local).map(&:first)
    end

    # @return [Array<Array<Pathname, String>>]
    #   an array of pathnames and their md5 digests for the local install.
    def local
      @local ||= parse_local
    end

    # @return [Array<Array<Pathname, String>>]
    #   an array of remote pathnames and their md5 digests from the patcher.
    def remote
      @remote ||= parse_remote
    end

    # Updates {#local} with a full scan of the installation directory.
    # @return [self]
    def scan
      @local = []
      recursive_scan
      @local = sort local
      save
    end

    private

    def parse(file)
      file.read.split("\n").map do |line|
        line.split(' | ').tap do |path, md5|
          [Pathname.new(path), md5.chomp]
        end
      end
    end

    def parse_local
      sort File.open(@local_index_path, 'r') { |file| parse file }
    rescue Errno::ENOENT
      []
    end

    def parse_remote
      sort Kernel.open(@remote_index_uri) { |file| parse file }
    rescue Errno::ENOENT
      []
    end

    def recursive_scan(target = @target_dir)
      target.each_child do |pathname|
        if pathname.file?
          @local << [pathname.to_s, Digest::MD5.file(pathname).to_s]
        elsif pathname.directory?
          recursive_scan pathname
        end
      end
    end

    def save
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
