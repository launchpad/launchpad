class Index
  attr_accessor :target, :files

  def initialize(target = '.')
    @target = Pathname.new target
    @files = []
  end

  def scan(target = @target)
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
