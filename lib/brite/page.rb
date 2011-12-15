require 'brite/model'

module Brite

  # Models a site page.
  class Page < Model

    # New Page.
    def initialize(site, file, copy={})
      @site = site
      @file = file

      initialize_defaults

      update(copy)

      @_template = Neapolitan.file(file, :stencil=>site.config.stencil) #site.page_defaults)

      update(@_template.metadata)
    end

    #
    def initialize_defaults
      @tags   = []
      @author = site.config.author
      @route  = site.config.page_route
      @layout = site.config.page_layout

      @extension = '.html'

      # these are filled-out as needed, but the instance variable
      # must define up front to ensure #to_h will pick them up.
      # Probably this should be done in a different way in the future.
      @output = nil
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

    # Output route.
    attr_accessor :route

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
    def output
      @output ||= calculate_output
    end

    # Set route directly, relative to file, overriding any slug.
    def output=(path)
      @output = path.sub(/^\//,'')
    end

    # Setting the peramlink is the same as setting output.
    alias_method :permalink=, :output=

    # Same as output but prefixed with `/`.
    def permalink
      '/' + output
    end

    alias_method :url, :permalink

    #
    #def url
    #  @url ||= config.url ? File.join(config.url, output) : permalink
    #end

    # The `name` is same as `output` but without any file extension.
    def name
      @name ||= output.chomp(extension)
    end

    #
    #attr_accessor :relative_url do
    #  output #File.join(root, output)
    #end

    # THINK: Is there any reason to have #work ?
    # Working directory of file being rendering.
    #def work
    #  @work ||= '/' + File.dirname(file)
    #end

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
    def calculate_output
      path = file.chomp(File.extname(file))
      name = File.basename(path)

      out = route.dup
      out = date.strftime(out) if out.index('%')
      out = out.sub(':path', path)
      out = out.sub(':name', name)
      out = out + extension
      out
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
