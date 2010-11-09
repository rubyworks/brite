# TODO: Make this a configuration option
#require 'gemdo'

module Brite

  # Context class provides a clean rendering context for rendering
  # pages and posts.
  #
  # The Context instance is passed to Malt (eg. ERB).
  class Context
    #instance_methods(true).each{ |m| private m unless m =~ /^(__|inspect$)/ }

    def initialize(attributes={})
      @attributes = attributes

      attributes.each do |k,v|
        (class << self; self; end).class_eval do
          define_method(k){ v }
        end
      end     
    end

    # Using ERB, the #render method can be used to render external files
    # and embed them in the current document. This is useful, for example,
    # when rendering a project's README file as part of a project website.
    #
    # The +file+ is rendered via Malt.
    def render(file, options={})
      options[:file] = file
      Malt.render(options)
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
