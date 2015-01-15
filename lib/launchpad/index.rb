class Index
  attr_accessor :files

  def initialize(options = {})
    @target_dir = Pathname.new options[:target_dir] || '.'
    @index_location = options[:index_location] || 'index'
    @files = []
  end

  def index_file
    @index_file ||= File.open @index_location, 'w'
  end

  def save
    scan if files.empty?

    files.each do |data|
      index_file.write "#{data[0]} - #{data[1]}\n"
    end

    index_file.close
    @index_file = nil

    self
  end

  def scan(target = @target_dir)
    target.each_child do |pathname|
      if pathname.file?
        @files << [ pathname, Digest::MD5.file(pathname) ]
      elsif pathname.directory?
        scan pathname
      end
    end

    self
  end
end
