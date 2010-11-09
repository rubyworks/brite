require 'ostruct'

module Brite

  # Configuration
  class Config

    # Configuration file name glob.
    CONFIG_FILE = '{.,}brite{,.yml,.yaml}'

    # Default URL, which is just for testing purposes.
    DEFAULT_URL     = 'http://0.0.0.0:4321'

    # Default stencil.
    DEFAULT_STENCIL = 'rhtml'

    # Default format.
    DEFAULT_FORMAT  = nil #html

    # Default page layout file name (less `.layout` extension).
    DEFAULT_PAGE_LAYOUT = 'page'

    # Default post layout file name (less `.layout` extension).
    DEFAULT_POST_LAYOUT = 'post'

    # Site's absolute URL. Where possible links are relative,
    # but it is not alwasy possible. So a URL should *ALWAYS*
    # be provided for the site.
    #--
    # TODO: Allow +url+ to be set via the command line when generating the site.
    #++
    attr_accessor :url

    # Defaut section template engine.
    attr_accessor :stencil

    # Default section markup format.
    attr_accessor :format

    # Default page layout file name.
    attr_accessor :page

    # Default post layout file name.
    attr_accessor :post

    # New instance of Config.
    def initialize
      @url     = DEFAULT_URL
      @stencil = DEFAULT_STENCIL
      @format  = DEFAULT_FORMAT
      @page    = DEFAULT_PAGE_LAYOUT
      @post    = DEFAULT_POST_LAYOUT
      configure
    end

    # Load configuration file.
    def configure
      if file = Dir[CONFIG_FILE].first
        data = YAML.load(File.new(file))
        data.each do |k,v|
          __send__("#{k}=", v)
        end
      end
    end

    #def initialize_defaults
    #  if file = Dir['{.,}config/defaults{,.yml,.yaml}'].first
    #    custom_defaults = YAML.load(File.new(file))
    #  else
    #    custom_defaults = {}
    #  end
    #  @defaults = OpenStruct.new(DEFAULTS.merge(custom_defaults))
    #end

    # FIXME: Is this used? What about page vs pagelayout?
    def defaults
      @defaults ||= OpenStruct.new(
        :stencil    => stencil,
        :format     => format,
        :pagelayout => page,
        :postlayout => post
      )
    end

    # Use Gemdo.
    def gemdo=(set)
      return unless set
      require 'gemdo'        
      Brite::Context.class_eval do
        def project
          @project ||= Gemdo::Project.new
        end
      end
    end

  end

end
