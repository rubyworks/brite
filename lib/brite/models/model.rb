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
    def initialize(settings={})
      @settings = settings

      settings.each do |k,v|
        if respond_to?("#{k}=")
          __send__("#{k}=",v)
        #else
        #  self[k] = v
        end
      end
    end

    #
    #def data
    #  @data ||= {}
    #end

    # Add entry to settings data.
    def []=(k,v)
      @settings[k.to_s] = v
    end

    #
    def method_missing(name, *a, &b)
      if @settings.key?(name.to_s)
        @settings[name.to_s]
      else
        nil #super(name, *a, &b)
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

