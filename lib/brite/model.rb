module Brite

  # Base class for all site classes.
  #
  class Model

    #
    def initialize(site, file, data={})
      @site  = site
      @files = file

      update(date)
    end

    attr_reader :site

    attr_reader :file

    #
    def config
      site.config
    end

    #
    # Render partial template.
    #
    def part(path)
      @part ||= (
        partial = site.lookup_partial(path.to_s)
        #if path
        #  partial = site.parts.find{ |part|
        #    part.name == path
        #  }
          raise "no such part -- #{path} from #{file}" unless partial
          partial.render
        #else
        #  Part::Manager.new(self)
        #end
      )
    end

    #
    def update(data)
      data.each do |k,v|
        self[k] = v
      end
    end

    # Add entry to settings data.
    def [](k)
      instance_variable_get("@#{k}")
    end

    # Add entry to settings data.
    def []=(k,v)
      if respond_to?("#{k}=")
        __send__("#{k}=", v)
      else
        instance_variable_set("@#{k}", v)
      end
    end

    #def to_ary
    #  p caller
    #  raise
    #end

    #
    def method_missing(name, *a, &b)
      instance_variable_get("@#{name}")
    end

    # Returns a Binding for this instance.
    def to_binding(&block)
      binding
    end

    # Returns a Hash of rendering fields.
    def to_h
      hash = {}
      fields = rendering_fields
      fields.each do |field|
        hash[field.to_s] = __send__(field)
      end
      hash
    end

    # Returns an Array of attribute/method names to be visible to the page
    # rendering.
    def rendering_fields
      list = []
      instance_variables.each do |iv|
        name = iv.to_s.sub('@','')
        next if name.start_with?('_')
        list << name
      end
      list
    end

    #
    #def singleton_class
    #  (class << self; self; end)
    #end

  end

end
