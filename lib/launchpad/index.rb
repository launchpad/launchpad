require 'open-uri'

# Provides a diff between local and remote file data by maintaining a cache
# with pathnames and md5 hex digests
class Index
  # @param [Hash] options
  # @option options [String] :target_dir root instllation directory
  # @option options [String] :local_index_path where the local index is cached
  # @option options [String] :remote_index_uri uri for the remote index
  def initialize(options = {})
    @target_dir = Pathname.new options[:target_dir]
    @local_index_path = options[:local_index_path]
    @remote_index_uri = options[:remote_index_uri]
  end

  # @return [Array<String>]
  #   an array of files that are not present or do not match the remote
  def diff
    (remote - local).map(&:first)
  end

  # @return [Array<Array<Pathname, String>>]
  #   an array of pathnames and their md5 digests for the local install
  def local
    @local ||= parse_local
  end

  # @return [Array<Array<Pathname, String>>]
  #   an array of remote pathnames and their md5 digests from the patcher
  def remote
    @remote ||= parse_remote
  end

  # Updates {#local} with a full scan of the installation directory
  # @return [self]
  def scan
    @local = []
    recursive_scan
    save
  end

  private

  def open_local
    File.open(@local_index_path, 'w')
  end

  def parse(file)
    file.read.split("\n").map do |line|
      line.split(' | ').tap do |path, md5|
        [ Pathname.new(path), md5.chomp ]
      end
    end
  end

  def parse_local
    File.open(@local_index_path, 'r') { |file| parse file }
  rescue Errno::ENOENT
    false
  end

  def parse_remote
    Kernel.open(@remote_index_uri) { |file| parse file }
  rescue Errno::ENOENT
    false
  end

  def recursive_scan(target = @target_dir)
    target.each_child do |pathname|
      if pathname.file?
        @local << [ pathname, Digest::MD5.file(pathname) ]
      elsif pathname.directory?
        recursive_scan pathname
      end
    end
  end

  def save
    file = open_local
    local.each do |data|
      file.write "#{data[0]} | #{data[1]}\n"
    end

    file.close
    self
  end
end
