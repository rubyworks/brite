require 'brite/model'

module Brite

  # Layout class
  class Layout < Model

    #
    def initialize(site, file)
      @site = site
      @file = file

      @name = file.chomp('.layout')
      @path = File.expand_path(file)
    end

    #
    attr :site

    #
    attr :file

    #
    attr :name

    #
    attr :path

    # TODO: merge layout header ?

    # Render layout.
    def render(model, &content)
      template = Neapolitan.file(path, :stencil=>site.config.stencil)

      # update the model's metadata
      #model.update(template.metadata)

      result = template.render(model, &content).to_s

      layout_name = template.metadata['layout']

      if layout_name
        layout = site.lookup_layout(layout_name)

        raise "No such layout -- #{layout}" unless layout

        result = layout.render(model){ result }
      end

      result.to_s
    end

  end

end
