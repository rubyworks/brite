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

end
