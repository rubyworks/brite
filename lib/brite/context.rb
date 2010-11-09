# TODO: Make this a configuration option
require 'gemdo'

module Brite

  # = Clean Rendering Context
  #
  # The Context is passed to Malt (eg. ERB).

  class Context
    #include TemplateFilters

    #instance_methods(true).each{ |m| private m unless m =~ /^(__|inspect$)/ }

    def initialize(attributes={})
      @attributes = attributes

      attributes.each do |k,v|
        (class << self; self; end).class_eval do
          define_method(k){ v }
        end
      end     
    end

    #
    def render(file, opts={})
      opts[:file] = file
      Malt.render(opts)
    end

    #
    def to_binding
      binding
    end

    #
    def to_h
      @attributes
    end

    #
    #def method_missing(s, *a)
    #  s = s.to_s
    #  @attributes.key?(s) ? @attributes[s] : super(s,*a)
    #end
  end

end
