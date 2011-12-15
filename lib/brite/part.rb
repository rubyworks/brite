module Brite

  # In you templates:
  #
  #   <%= part.some_part_name %>
  #
  class Part < Model

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
      @layout = nil

      @part = nil 
      @name = nil
      @basename = nil
    end

    #
    def name
      @name ||= file.chomp('.part')
    end

    #
    def basename
      @basename ||= File.basename(name)
    end

    # Render page or post template.
    #
    def render
      render = @_template.render(self) #, &body)

      result = render.to_s

      if layout
        if layout_object = site.lookup_layout(layout)
          result = layout_object.render(self){ result }
        #else
        #  raise "No such layout -- #{layout}"
        end
      end

      result.to_s.strip
    end

    #
    class Manager

      def initialize(model)
        @model = model
        @site  = model.site

        @parts = {}
        model.site.parts.each do |part|
          @parts[part.basename] = part
        end
      end

      #
      def to_h
        @parts
      end

      #
      def method_missing(name, *args, &block)
        @parts[name.to_s].render
      end
 
    end

  end

end

