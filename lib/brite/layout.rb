module Brite

  # Layout class
  class Layout

    #
    def initialize(controller, file)
      @controller = controller
      @file       = file
      @name       = file.chomp('.layout')
      @path       = File.expand_path(file)
    end

    attr :controller

    attr :file

    attr :path

    attr :name

    # TODO: merge in layout header
    def render(model, &content)
      template = Neapolitan.file(path, :stencil=>controller.config.stencil)

      result = template.render(model, &content).to_s

      layout = template.header['layout']

      if layout
        layout = controller.lookup_layout(layout)
        raise "No such layout -- #{layout}" unless layout
        result = layout.render(model){ result }
      end

      result.to_s
    end

  end

=begin
  # Layout class
  class Layout < Page

    # Layouts cannot be saved.
    undef_method :save

    #def to_contextual_attributes
    #  { 'site'=>site.to_h }
    #end

    #
    def render(scope=nil, &content)
      if scope
        scope.merge!(attributes)
      else
        scope = Scope.new(self, fields, attributes)
      end

      result = template.render(scope, &content).to_s

      if layout
        result = site.lookup_layout(layout).render(scope){ result }
      end

      result.to_s
    end

    # Layouts have no default layout.
    def default_layout
      nil
    end

  end
=end

end
