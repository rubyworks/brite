require 'neapolitan'
#require 'brite/part'
require 'brite/context'

module Brite

  # Page class
  class Page

    # TODO: I don't much care for how the fields are being handled.

    #
    def self.fields(anc=false)
      if anc
        f = []
        ancestors.reverse_each do |a|
          f.concat(a.fields) if a.respond_to?(:fields)
        end
        f
      else
        @fields ||= []
      end
    end

    #
    def self.field(*names)
      names.each do |name|
        fields << name.to_sym
      end
    end

    #
    #def self.field(name, &default)
    #  name = name.to_sym
    #  fields << name
    #  if default
    #    define_method(name) do
    #      @attributes[name] ||= instance_eval(&default)
    #    end
    #  else
    #    define_method(name) do
    #      @attributes[name]
    #    end
    #  end
    #  define_method("#{name}=") do |value|
    #    @attributes[name] = value
    #  end
    #end

    # New Page.
    def initialize(site, file)
      @attributes = {}

      self.site = site

      @file    = file
      @output  = nil

      @layout  = default_layout

      parse
    end

    #
    def config
      site.config
    end

    # Path of page file.
    def file
      @file
    end

    # Template type (`rhtml` or `liquid` are good choices).
    def stencil
      @stencil
    end

    # Layout name (relative file name less extension).
    def layout
      @layout
    end

    #
    def layout=(layout)
      case layout
      when false, nil
        @layout = nil
      else
        @layout = layout
      end
    end

    # Returns an instance of Neapolitan::Template.
    def template
      @template
    end

    #
    attr :attributes

    #
    #attr :header

    # Returns a list of fields. Fields are the attributes/methods visible
    # to a template via the Scope class.
    def fields
      self.class.fields(true)
    end

    #
    def output
      @output ||= file.chomp(File.extname(file)) + extension
    end

    #
    def output=(fname)
      @output = File.join(File.dirname(file), fname) if fname
      @output
    end

    # Output extension (defualt is 'html')
    def extension
      @extension ||= '.html'
    end

    # Set output extension.
    def extension=(extname)
      @extension = (
        e = (extname || 'html').to_s
        e = '.' + e unless e.start_with?('.')
        e
      )
    end

    field :site, :author, :title, :date, :category, :tags, :url
    field :root, :work, :path, :summary

    # Instance of Site class to which this page belongs.
    attr_accessor :site

    # Author
    attr_accessor :author # 'Anonymous'

    # Title of page/post
    attr_accessor :title

    # Publish date
    def date
      @date ||= (date_from_filename(file) || Time.now)
    end

    def date=(date)
      @date = date
    end

    # Category ("a glorified tag")
    attr_accessor :category

    # Tags (labels)
    def tags
      @tags ||= []
    end

    #
    def tags=(entry)
      case entry
      when String, Symbol
        entry = entry.to_s.strip
        if entry.index(/[,;]/)
          entry = entry.split(/[,;]/)
        else
          entry = entry.split(/\s+/)
        end
      else
        entry = entry.to_a.flatten
      end
      @attributes[:tags] = entry.map{ |e| e.strip }
    end

    #
    def name
      @name ||= file.chomp(File.extname(file))
    end

    #
    def url
      File.join(site.url, name + extension)
    end

    #
    #def relative_url
    #  output #File.join(root, output)
    #end

    #
    def path
      name + extension
    end

    # DEPRECATE: Get rid of this and use rack to test page instead of files.
    # OTOH, that may not alwasy be possible we may need to keep this.
    def root
      '../' * file.count('/')
    end

    # Working directory of file being rendering. (Why a field?)
    def work
      '/' + File.dirname(file)
    end

    # Summary is the rendering of the first part.
    attr_accessor :summary

    #
    def dryrun?
      site.dryrun
    end

    #
    def to_scope
      Scope.new(self, fields, attributes)
    end

    #
    def to_h
      scope.to_h.inject({}){ |h,(k,v)| h[k.to_s] = v; h }
      #prime_defaults
      #hash = {}
      #@attributes.each do |k,v|
      #  hash[k.to_s] = v
      #end
      #hash
    end

=begin
    # Convert pertinent information to a Hash to be used in rendering.
    def to_contextual_attributes
      prime_defaults
      hash = {}
      @attributes.each do |k,v|
        if v.respond_to?(:to_h)
          hash[k.to_s] = v.to_h
        else
          hash[k.to_s] = v
        end
      end
      hash['page'] = self
      #to_h.merge(
      #  'site'=>site.to_h, 'page'=>to_h, 'root'=>root, 'work'=>work, 'project'=>site.project
      #)
      hash
    end

    #
    def to_liquid
      to_contextual_attributes
    end

    #
    def prime_defaults
      self.class.fields(true).each do |field|
        __send__(field)
      end
    end
=end

    #
    def save(dir=nil)
      dir   = dir || Dir.pwd  # TODO
      text  = render{''}
      fname = output
      if dryrun?
        puts "[DRYRUN] write #{fname}"
      else
        if File.exist?(fname)
          current = File.read(fname)
        else
          current = nil
        end
        if current != text or $FORCE
          puts "  write: #{fname}"
          File.open(fname, 'w'){ |f| f << text }
        else
          puts "   kept: #{fname}"
        end
      end
    end

    #
    def render(scope=nil, &body)
      #attributes = to_contextual_attributes
      #attributes = attributes.merge(inherit)

      if scope
        scope.merge!(attributes)
      else
        scope = to_scope
      end

      render = template.render(scope, &body)

      self.summary = render.summary  # TODO: make part of neapolitan?

      result = render.to_s

      if layout
        renout = site.lookup_layout(layout)
        raise "No such layout -- #{layout}" unless renout
        result = renout.render(scope){ result }
      end

      result.to_s.strip
    end

    # Default layout is different for pages vs. posts, so we
    # use this method to differntiation them.
    def default_layout
      site.config.page_layout
    end

    #
    def to_s
      file
    end

    #
    def inspect
      "<#{self.class}: #{file}>"
    end

    private

    #
    def parse
      @template   = Neapolitan.file(file, :stencil=>site.config.stencil)

      header = @template.header

      self.output = header.delete('output')
      self.layout = header.delete('layout')
      #self.stencil  = @attributes.delete('stencil') || site.defaults.stencil
      #self.extension = @attributes.delete('extension')

      @attributes = {}

      header.each do |k,v|
        if self.class.fields.include?(k.to_sym) && respond_to?("#{k}=")
          __send__("#{k}=",v)
        else
          @attributes[k.to_sym] = v
        end
      end
    end

    #
    def date_from_filename(file)
      if md = (/^\d\d\d\d-\d\d-\d\d/.match(file))
        md[1]
      else
        File.mtime(file)
      end
    end

  end

end
