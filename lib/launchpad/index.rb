class Index
  attr_accessor :local_files

  def initialize(options = {})
    @target_dir = Pathname.new options[:target_dir] || '.'
    @index_location = options[:index_location] || 'index'
    @local_files = []
  end

  def local_index(mode: 'r')
    @local_index ||= File.open @index_location, mode
  end

  def load
    local_index.each_line do |line|
      line.split(' | ').tap do |path, md5|
        @local_files << [ Pathname.new(path), md5.chomp ]
      end
    end
  rescue Errno::ENOENT
    return false
  else
    close
    true
  end

  def save
    scan if local_files.empty?

    local_files.each do |data|
      local_index(mode: 'w').write "#{data[0]} | #{data[1]}\n"
    end

    close
    self
  end

  def scan(target = @target_dir)
    target.each_child do |pathname|
      if pathname.file?
        @local_files << [ pathname, Digest::MD5.file(pathname) ]
      elsif pathname.directory?
        scan pathname
      end
    end

    self
  end

  private

  def close
    local_index.close
    @local_index = nil
  end
end
