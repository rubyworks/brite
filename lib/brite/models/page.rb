require 'brite/models/model'

module Brite

  #
  class Page < Model

    # New Page.
    def initialize(settings={}, &rendering)
      @site      = settings[:site]
      @file      = settings[:file]

      initialize_defaults

      @rendering = rendering

      super(settings)
    end

    # Instance of Site class to which this page belongs.
    attr_accessor :site

    #
    attr_accessor :file

    # Author
    attr_accessor :author

    # Title of page/post
    attr_accessor :title

    # Publish date
    attr_accessor :date

    def date
      @date ||= date_from_filename(file) || Time.now
    end

    # Category ("a glorified tag")
    attr_accessor :category

    # Is this page a draft? If so it will not be rendered.
    attr_accessor :draft

    # Query alias for #draft.
    alias_method :draft?, :draft

    # Output slug.
    attr_accessor :slug

    # Layout to use for page.
    attr_accessor :layout

    # Tags (labels)
    attr_accessor :tags

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
    def route
      @route ||= calculate_route
    end

    #
    attr_accessor :url

    def url
      @url ||= \
        #File.join(site.url, name + extension)
        name + extension
    end

    # Save As
    def output
      #@output ||= file.chomp(File.extname(file)) + extension
      @output ||= route + extension
    end

    #
    #def output=(fname)
    #  @output = File.join(File.dirname(file), fname) if fname
    #  @output
    #end

    #
    def name
      @name ||= file.chomp(File.extname(file))
    end

    #
    #attr_accessor :relative_url do
    #  output #File.join(root, output)
    #end

    #
    def path
      @path ||= '/' + name + extension
    end

    # DEPRECATE: Get rid of #root  and use rack to test page instead of files.
    # OTOH, that may not always be possible we may need to keep this ?

    #
    def root
      @root ||= '../' * file.count('/')
    end

    # Working directory of file being rendering. (Why a field?)
    def work
      @work ||= '/' + File.dirname(file)
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

    #
    def calculate_route
      path = file.chomp(File.extname(file))
      name = File.basename(path)

      route = slug.dup
      route = date.strftime(route) if route.index('%')
      route = path.sub('$path', path)
      route = path.sub('$name', name)
      #route = route + extension
      route
    end

    #
    def initialize_defaults
      @layout = @site.config.page_layout
      @slug   = @site.config.page_slug
      @author = @site.config.author
    end

  end

end
