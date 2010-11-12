module Birte

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

end

