require 'ostruct'

module Brite

  # Configuration
  class Config

    #
    DEFAULTS = {
      :stencil => 'rhtml',
      :format  => nil, #'html',
      :page    => 'page',
      :post    => 'post'
    }

    attr_accessor :url

    # Defaut section template engine
    attr_accessor :stencil

    # Default section markup format
    attr_accessor :format

    # Default page layout
    attr_accessor :page

    # Default post layout
    attr_accessor :post

    #
    def initialize
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

    def defaults
      @defaults ||= OpenStruct.new(
        :stencil    => stencil,
        :format     => format,
        :pagelayout => page,
        :postlayout => post
      )
    end

  end

end

