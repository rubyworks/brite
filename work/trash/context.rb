# TODO: Make this a configuration option
#require 'gemdo'
require 'erb'

module Brite

  # The Scope class provides a clean context for rendering pages and posts.
  # An instance of Scope is passed to Malt (eg. ERB).
  class Scope
    include ERB::Util

    #instance_methods(true).each{ |m| private m unless m =~ /^(__|inspect$)/ }

    def initialize(delegate, fields, attributes={})
      @delegate   = delegate
      @fields     = fields
      @attributes = attributes

      fields.each do |f|
        (class << self; self; end).class_eval do
          define_method(f){ delegate.__send__(f) }
        end
      end

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
    def to_binding(&yld)
      binding
    end

    #
    def to_h
      hash = {}
      @fields.each do |field|
        hash[field] = @delegate.__send__(field)
      end
      hash.merge(@attributes)
    end

    #
    def to_liquid
      to_h
    end

    #
    def merge!(hash)
      @attributes.merge!(hash)
      hash.each do |k,v|
        (class << self; self; end).class_eval do
          define_method(k){ v }
        end
      end
    end

    #
    #def method_missing(s, *a)
    #  s = s.to_s
    #  @attributes.key?(s) ? @attributes[s] : super(s,*a)
    #end
  end

end
