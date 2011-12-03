require 'brite/models/model'

module Brite

  # Models a site page.
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

    # The `.page` file.
    attr_accessor :file

    # Author of page.
    attr_accessor :author

    # Title of page/post.
    attr_accessor :title

    # Publish date.
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

    # The page's route, which is effectively the "Save As" output file.
    def route
      @route ||= calculate_route
    end

    #
    alias_method :output, :route

    # Set route directly, relative to file, overriding any slug.
    def route=(fname)
      @route = File.join(File.dirname(file), fname) + extension
    end

    #
    alias_method :output=, :route=

    # The `name` is same as `route` but without any file extension.
    def name
      @name ||= route.chomp(extension)
    end

    #
    attr_accessor :url

    #
    def url
      @url ||= route  #site.url ? File.join(site.url, route) : route
    end

    #
    #attr_accessor :relative_url do
    #  output #File.join(root, output)
    #end

    # TODO: Why is #path prefixed with '/' ?

    # Path is the same as route but prefixed with `/`.
    def path
      @path ||= '/' + route
    end

    # TODO: Not sure we should have #work, and why prefixed with '/'?

    # Working directory of file being rendering.
    def work
      @work ||= '/' + File.dirname(file)
    end

    # Relative path difference between the route and the site's root.
    # The return value is a string of `..` paths, e.g. `"../../"`.
    #
    # @return [String] multiples of `../`.
    def root
      #@root ||= '../' * file.count('/')
      @root ||= '../' * (output.count('/') - (output.count('../')*2))
    end

    # Output extension (defualts to 'html').
    def extension
      @extension ||= '.html'
    end

    # Set output extension.
    #
    # @param [String] extname
    #   The file extension.
    #
    def extension=(extname)
      @extension = (
        e = (extname || 'html').to_s
        e = '.' + e unless e.start_with?('.')
        e
      )
    end

    # TODO: Summary is being set externally, is there a way to fix ?

    # Summary is the rendering of the first part.
    attr_accessor :summary

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
      route = route + extension
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
