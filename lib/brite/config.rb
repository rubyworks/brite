require 'ostruct'

module Brite

  # Configuration
  class Config

    #
    DEFAULTS = {
      :url     => 'http://0.0.0.0:4321',
      :stencil => 'rhtml',
      :format  => nil, #'html',
      :page    => 'page',
      :post    => 'post'
    }

    # Site's absolute URL. Where possible links a relative,
    # but it is not alwasy possible. So a URL should *ALWAYS*
    # be provided for the site.
    #
    # TODO: Allow +url+ to be set via the command line when
    # generating the site.
    attr_accessor :url

    # Defaut section template engine.
    attr_accessor :stencil

    # Default section markup format.
    attr_accessor :format

    # Default page layout.
    attr_accessor :page

    # Default post layout.
    attr_accessor :post

    #
    def initialize
      @url     = DEFAULTS[:url]
      @stencil = DEFAULTS[:stencil]
      @format  = DEFAULTS[:format]
      @page    = DEFAULTS[:page]
      @post    = DEFAULTS[:post]
      configure
    end

    def configure
      if file = Dir['{.,}brite{,.yml,.yaml}'].first
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
      Brite::TemplateContext.class_eval do
        def project
          @project ||= Gemdo::Project.new
        end
      end
    end

  end

end
