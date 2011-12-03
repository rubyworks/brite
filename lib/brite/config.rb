require 'yaml'
require 'ostruct'

module Brite

  # Configuration
  class Config

    # Configuration file name glob.
    CONFIG_FILE         = '{.brite,brite.yml,brite.yaml}'

    # Default URL, which is just for testing purposes.
    DEFAULT_URL         = 'http://0.0.0.0:3000'

    # Default stencil.
    DEFAULT_STENCIL     = 'rhtml' #'liquid' # 'rhtml'

    # Default format.
    DEFAULT_FORMAT      = nil #html

    # Default page layout file name (less `.layout` extension).
    DEFAULT_PAGE_LAYOUT = 'page'

    # Default post layout file name (less `.layout` extension).
    DEFAULT_POST_LAYOUT = 'post'

    # Default page slug (`$path`).
    DEFAULT_PAGE_SLUG   = '$path'

    # Default post slug (`$path`).
    DEFAULT_POST_SLUG   = '$path'

    # Default author for pages and posts.
    DEFAULT_AUTHOR      = 'Anonymous'

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

    # Default page slug.
    attr_accessor :page_slug

    # Default post slug.
    attr_accessor :post_slug

    # Default author.
    attr_accessor :author

    # New instance of Config.
    def initialize(location=nil)
      @location    = location || Dir.pwd
      @file        = Dir.glob(File.join(@location, CONFIG_FILE)).first

      @url         = DEFAULT_URL
      @stencil     = DEFAULT_STENCIL
      @format      = DEFAULT_FORMAT

      @page_layout = DEFAULT_PAGE_LAYOUT
      @post_layout = DEFAULT_POST_LAYOUT

      @page_slug   = DEFAULT_PAGE_SLUG
      @post_slug   = DEFAULT_POST_SLUG

      @author      = DEFAULT_AUTHOR

      configure
    end

    # Load configuration file.
    def configure
      if file
        data = YAML.load(File.new(file))
        data.each do |k,v|
          __send__("#{k}=", v)
        end
      end
    end

    # Provide access to POM.
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

  end

end
