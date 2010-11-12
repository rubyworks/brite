module Brite

  #
  class Model

    # Designate a field to be omitted from rendering context.
    def self.omit_field(name)
      omit_fields << (RUBY_VERSION >= "1.9" ? name.to_sym : name.to_s)
    end

    # Returns an Array of omitted fields for this class.
    def self.omit_fields
      @omit_fields ||= []
    end

    #
    def self.attr_accessor(name, &default)
      name = name.to_sym
      if default
        define_method(name) do
          value = instance_variable_get("@#{name}") || instance_eval(&default)
          (class << self; self; end).class_eval do
            define_method(name){ value }
          end
          value
        end
      else
        attr_reader(name)
      end
      attr_writer(name)
    end

    # Define a singleton method for given key-value pair.
    def []=(k,v)
      (class << self; self; end).class_eval do
        define_method(k){v}
      end
    end

    # Returns a Binding for this instance.
    def to_binding(&block)
      binding
    end

    # Returns a Hash of rendering fields.
    def to_h
      hash   = {}
      fields = rendering_fields
      fields.each do |field|
        hash[field.to_s] = __send__(field)
      end
      #extra.each do |k,v|
      #  hash[k.to_s] == v
      #end
      hash
    end

    # In case Liquid template is used.
    def to_liquid
      to_h
    end

    # Returns an Array of attribute/method names to be visible to the page
    # rendering.
    def rendering_fields
      list = public_methods 
      list -= Model.public_instance_methods
      list -= omit_fields
      list.select do |name|
        case name.to_s
        when /\W+/  then false
        when /^to_/ then false
        else
          true
        end
      end
    end

    # Returns an Array of attribute/method names explicitly omitted from
    # being visible from the rendering.
    def omit_fields
      list = []
      self.class.ancestors.reverse_each do |ancestor|
        list.concat(ancestor.omit_fields) if ancestor.respond_to?(:omit_fields)
      end
      list
    end

    #
    def singleton_class
      (class << self; self; end)
    end

  end

end

