module Brite

  # Layout class
  class Layout

    #
    def initialize(site, file)
      @site = site
      @file = file
      @name = file.chomp('.layout')
      @path = File.expand_path(file)
    end

    attr :site

    attr :file

    attr :path

    attr :name

    # TODO: merge in layout header
    def render(model, &content)
      template = Neapolitan.file(path, :stencil=>site.config.stencil)

      result = template.render(model, &content).to_s

      layout = template.header['layout']

      if layout
        layout = site.lookup_layout(layout)
        raise "No such layout -- #{layout}" unless layout
        result = layout.render(model){ result }
      end

      result.to_s
    end

  end

end
