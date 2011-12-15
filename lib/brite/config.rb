require 'yaml'
require 'ostruct'

module Brite

  # Configuration
  class Config

    # Configuration file name glob.
    CONFIG_FILE          = '{.brite,brite.yml,brite.yaml}'

    # Default URL, which is just for testing purposes.
    DEFAULT_URL          = 'http://0.0.0.0:3000'

    # Default stencil.
    DEFAULT_STENCIL      = 'erb'

    # Default format.
    DEFAULT_FORMAT       = nil #html

    # Default page layout file name (less `.layout` extension).
    DEFAULT_PAGE_LAYOUT  = 'page'

    # Default post layout file name (less `.layout` extension).
    DEFAULT_POST_LAYOUT  = 'post'

    # Default page route (`:path`).
    DEFAULT_PAGE_ROUTE   = ':path'

    # Default post route (`:path`).
    DEFAULT_POST_ROUTE   = ':path'

    # Default author for pages and posts.
    DEFAULT_AUTHOR       = 'Anonymous'

    # Default location of layouts.
    DEFAULT_LAYOUT_PATH  = ['assets/layouts']

    # Default location of partials.
    DEFAULT_PARTIAL_PATH = ['assets/partials']

    # Location of brite project files. By necessity the configuration file
    # will be located in this directory.
    attr :location

    # Configuration file.
    attr :file

    # Site's absolute URL. Where possible links are relative,
    # but it is not alwasy possible. So a URL should *ALWAYS*
    # be provided for the site.
    attr_accessor :url

    # Defaut section template engine.
    attr_accessor :stencil

    # Default section markup format.
    attr_accessor :format

    # Default page layout file name (less extension).
    attr_accessor :page_layout

    # Default post layout file name (less extension).
    attr_accessor :post_layout

    # Default page route.
    attr_accessor :page_route

    # Default post route.
    attr_accessor :post_route

    # Default author.
    attr_accessor :author

    # Paths to look for layouts.
    attr_accessor :layout_path

    # Paths to look for layouts.
    attr_accessor :partial_path

    # New instance of Config.
    def initialize(location=nil)
      @location     = location || Dir.pwd
      @file         = Dir.glob(File.join(@location, CONFIG_FILE)).first

      @url          = DEFAULT_URL
      @stencil      = DEFAULT_STENCIL
      @format       = DEFAULT_FORMAT

      @page_layout  = DEFAULT_PAGE_LAYOUT
      @post_layout  = DEFAULT_POST_LAYOUT

      @page_route   = DEFAULT_PAGE_ROUTE
      @post_route   = DEFAULT_POST_ROUTE

      @author       = DEFAULT_AUTHOR

      @layout_path  = DEFAULT_LAYOUT_PATH
      @partial_path = DEFAULT_PARTIAL_PATH

      @custom      = {}

      configure
    end

    #
    # Load configuration file.
    #
    def configure
      if file
        data = YAML.load(File.new(file))
        data.each do |k,v|
          __send__("#{k}=", v)
        end
      end
    end

    #
    # Make sure layout_path is a list.
    #
    def layout_path=(path)
      @layout_path = [path].flatten
    end

    #
    # Make sure partial_path is a list.
    #
    def partial_path=(path)
      @partial_path = [path].flatten
    end

=begin
    #
    # Locate a layout looking in layout paths.
    #
    def find_layout(name)
      # look for layout in layout_path locations
      file = nil
      @layout_path.find do |path|
        file = Dir.glob(File.join(path, "#{name}.layout")).first
      end
      # fallback to site's root location
      if !file
        file = Dir.glob(File.join(@location, "#{name}.layout")).first
      end
      # if not found raise an error
      raise "Cannot locate layout #{name}." unless file
      # return layout file
      file
    end
=end

    #
    # Provide access to POM.
    #
    # @todo Will become GemDo in future ?
    #
    def pom=(set)
      return unless set
      require 'pom'
      Brite::Context.class_eval do
        def project
          @project ||= POM::Project.new
        end
      end
    end

    #
    alias_method :gemdo=, :pom=

    #
    def method_missing(s, v=nil, *a, &b)
      s = s.to_s
      case s
      when /=$/
        @custom[s.chomp('=')] = v
      else
        if @custom.key?(s)
          @custom[s]
        else
          super(s.to_sym, v, *a, &b)
        end
      end
    end

  end

end
