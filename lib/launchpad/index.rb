require 'open-uri'

class Index
  attr_accessor :local, :remote
  attr_writer :local_index_path, :remote_index_uri

  def initialize(options = {})
    @target_dir = Pathname.new options[:target_dir]
    @local_index_path = options[:local_index_path]
    @remote_index_uri = options[:remote_index_uri]
  end

  def diff
    (@remote - @local).map(&:first)
  end

  def local
    @local ||= parse_local
  end

  def remote
    @remote ||= parse_remote
  end

  def scan(target = @target_dir)
    @local = []
    recursive_scan target
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

  def recursive_scan(target)
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
