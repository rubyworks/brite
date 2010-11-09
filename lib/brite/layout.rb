module Brite

  # Layout class
  class Layout < Page

    # Layouts cannot be saved.
    undef_method :save

    #def to_contextual_attributes
    #  { 'site'=>site.to_h }
    #end

    #
    def render(attributes={}, &content)

      #attributes = to_contextual_attributes
      #attributes['content'] = content if content
      #output = parts.map{ |part| part.render(stencil, attributes, &content) }.join("\n")

      #@content = output
      #attributes = attributes.merge('content'=>output)

      context = Context.new(attributes)

      output = @template.render(context, &content).to_s

      if layout
        output = site.lookup_layout(layout).render(context){ output }
      end

      output
    end

    # Layouts have no default layout.
    def default_layout
      nil
    end

  end

end
