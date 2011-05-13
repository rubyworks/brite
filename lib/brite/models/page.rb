require 'brite/models/model'

module Brite

  #
  class Page < Model

    # New Page.
    def initialize(settings={}, &rendering)
#p settings
#puts
      settings.each do |k,v|
        if respond_to?("#{k}=")
          __send__("#{k}=",v)
        else
          self[k] = v
        end
      end

      @rendering = rendering
    end

    #
    attr_accessor :file

    # Instance of Site class to which this page belongs.
    attr_accessor :site

    # Author
    attr_accessor :author do
      'Anonymous'
    end

    # Title of page/post
    attr_accessor :title

    # Publish date
    attr_accessor :date do
      date_from_filename(file) || Time.now
    end

    # Category ("a glorified tag")
    attr_accessor :category

    # Tags (labels)
    attr_accessor :tags

    # Is this page a draft? If so it will not be rendered.
    attr_accessor :draft

    #
    def tags=(entry)
      case entry
      when String, Symbol
        entry = entry.to_s.strip
        if entry.index(/[,;]/)
          entry = entry.split(/[,;]/)
        else
          entry = entry.split(/\s+/)
        end
      else
        entry = entry.to_a.flatten
      end
      @tags = entry.map{ |e| e.strip }
    end

    #
    attr_accessor :url do
      #File.join(site.url, name + extension)
      name + extension
    end

    #
    attr_accessor :layout do
      'page'
    end

    #
    def output
      @output ||= file.chomp(File.extname(file)) + extension
    end

    #
    def output=(fname)
      @output = File.join(File.dirname(file), fname) if fname
      @output
    end

    #
    def name
      @name ||= file.chomp(File.extname(file))
    end

    #
    #attr_accessor :relative_url do
    #  output #File.join(root, output)
    #end

    #
    attr_accessor :path do
      '/' + name + extension
    end

    # DEPRECATE: Get rid of this and use rack to test page instead of files.
    # OTOH, that may not alwasy be possible we may need to keep this.
    attr_accessor :root do
      '../' * file.count('/')
    end

    # Working directory of file being rendering. (Why a field?)
    attr_accessor :work do
      '/' + File.dirname(file)
    end

    # Summary is the rendering of the first part.
    attr_accessor :summary

    # Output extension (defualt is 'html')
    def extension
      @extension ||= '.html'
    end

    # Set output extension.
    def extension=(extname)
      @extension = (
        e = (extname || 'html').to_s
        e = '.' + e unless e.start_with?('.')
        e
      )
    end

    # Renders page template.
    def to_s
      @rendering.call(self)
    end

    private

    #
    def date_from_filename(file)
      if md = (/^\d\d\d\d-\d\d-\d\d/.match(file))
        md[1]
      else
        File.mtime(file)
      end
    end

  end

end
