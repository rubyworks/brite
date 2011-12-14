require 'brite/models/model'

module Brite

  # Models a site page.
  class Page < Model

    # New Page.
    def initialize(site, file)
      @site = site
      @file = file

      initialize_defaults

      @_template = Neapolitan.file(file, :stencil=>site.config.stencil) #site.page_defaults)

      update(@_template.metadata)
    end

    #
    def initialize_defaults
      @tags = []
      @author = site.config.author
      @slug   = site.config.page_slug
      @layout = site.config.page_layout #@site.config.find_layout()

      @extension = '.html'

      @route  = nil
      @path   = nil
      @name   = nil
      @url    = nil
      @root   = nil
    end

    # Instance of Site class to which this page belongs.
    attr_reader :site

    # The `.page` file.
    attr_reader :file

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
      @root ||= '../' * (output.count('/') - (output.scan('../').length*2))
    end

    # Output extension (defualts to 'html').
    def extension
      @extension #||= '.html'
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
      render
    end

    #
    def inspect
      "#<#{self.class} #{@file}>"
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

    # Render page or post.
    #
    # @param [Neapolitan::Template] template
    #   Template to be rendered.
    #
    # @param [Model] model
    #   Page or Post model to use for rendering.
    #
    def render
      render = @_template.render(self) #, &body)

      self.summary = render.summary  # TODO: make part of neapolitan?

      result = render.to_s

      if layout
        if layout_object = site.lookup_layout(layout)
          result = layout_object.render(self){ result }
        #else
        #  raise "No such layout -- #{layout}" unless layout
        end
      end

      result.to_s.strip
    end

  end

end
