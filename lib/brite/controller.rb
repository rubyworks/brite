require 'neapolitan'
require 'brite/config'
require 'brite/layout'
require 'brite/models/site'
require 'brite/models/page'
require 'brite/models/post'

module Brite

  # The Controller class is the primary Brite class, handling
  # the generation of site files.
  class Controller

    # New Controller.
    def initialize(options={})
      @location = options[:location] || Dir.pwd
      @output   = options[:output]
      @url      = options[:url]
      @dryrun   = options[:dryrun]
      @trace    = options[:trace]

      @layouts  = []

      initialize_site
    end

    # Returns an instance of Site.
    def initialize_site
      @site = Site.new(:url=>url)

      Dir.chdir(location) do
        files = Dir['**/*']
        files.each do |file|
          name = File.basename(file)
          ext  = File.extname(file)
          case ext
          when '.layout'
            layouts << Layout.new(self, file)
          when '.page' #*%w{.markdown .rdoc .textile .whtml}
            @site.pages << initialize_page(file)
          when '.post'
            @site.posts << initialize_post(file)
          end
        end
      end
      @site.posts.sort!{ |a,b| b.date <=> a.date }
      @site
    end

    # Returns an instance of Page.
    #++
    # TODO: Limit Neapolitan to Markup formats only.
    #--
    def initialize_page(file)
      template = Neapolitan.file(file, :stencil=>config.stencil)
      settings = template.header

      settings[:site] = site
      settings[:file] = file

      Page.new(settings){ |page| render(template, page) }
    end

    # Returns an instance of Post.
    def initialize_post(file)
      template = Neapolitan.file(file, :stencil=>config.stencil)
      settings = template.header

      settings[:site] = site
      settings[:file] = file

      Post.new(settings){ |post| render(template, post) }
    end

    # Returns an instance of Site.
    attr :site

    #
    attr :location

    #
    attr :output

    # Is `dryrun` mode on?
    def dryrun?
      @dryrun
    end

    # Is `trace` mode on?
    def trace?
      @trace
    end

    # Returns an Array of Layouts.
    def layouts
      @layouts
    end

    # Access to configuration file data.
    def config
      @config ||= Config.new(location)
    end

    # URL of site as set in initializer or configuration file.
    def url
      @url ||= config.url
    end

    #
    def render(template, model) #scope=nil, &body)
      #if scope
      #  scope.merge!(attributes)
      #else
      #  scope = to_scope
      #end

      render = template.render(model) #, &body)

      model.summary = render.summary  # TODO: make part of neapolitan?

      result = render.to_s

      if model.layout
        layout = lookup_layout(model.layout)
        raise "No such layout -- #{layout}" unless layout
        result = layout.render(model){ result }
      end

      result.to_s.strip
    end

    # Lookup layout by name.
    def lookup_layout(name)
      layouts.find{ |layout| name == layout.name }
    end

    # Build site.
    def build
      if trace?
        puts "Layouts: " + layouts.map{ |layout| layout.name }.join(", ")
        puts "Pages:   " + pages.map{ |page| page.file }.join(", ")
        puts "Posts:   " + posts.map{ |post| post.file }.join(", ")
        puts
      end
      Dir.chdir(location) do
        site.posts.each do |post|
          save(post)
        end
        site.pages.each do |page|
          save(page)
        end
      end
      puts "#{site.pages.size + site.posts.size} Files: #{site.pages.size} Pages, #{site.posts.size} Posts"
    end

    # Save page/post redering to disk.
    def save(model)
      file = output ? File.join(output, model.output) : model.output
      text = model.to_s

      if File.exist?(file)
        current = File.read(file)
      else
        current = nil
      end

      if current != text or $FORCE
        if dryrun?
          puts "    dry run: #{file}"
        else
          puts "      write: #{file}"
          File.open(file, 'w'){ |f| f << text }
        end
      else
        puts "  unchanged: #{file}"
      end
    end

  end

end
