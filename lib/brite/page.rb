require 'neapolitan'
#require 'brite/part'
require 'brite/context'

module Brite

  # Page class
  class Page

    # New Page.
    def initialize(site, file)
      @site    = site
      @file    = file

      @output  = nil
      @summary = nil  # TODO: make part of neapolitan?

      @attributes = {}

      @layout  = default_layout

      parse
    end

    # Path of page file.
    attr :file

    # Instance of Site class to which this page belongs.
    attr :site

    # Template type (rhtml or liquid)
    attr_accessor :stencil

    # Layout name (relative filename less extension)
    attr :layout

    #
    def layout=(layout)
      case layout
      when false, nil
        @layout = nil
      else
        @layout = layout
      end
    end

    #
    attr :attributes

    #
    #attr :header

    # Author
    #attr :author

    # Title of page/post
    #attr :title

    # Publish date
    #attr :date

    # Tags (labels)
    #attr :tags

    # Category ("a glorified tag")
    #attr :category

    # Rendering of each part.
    #attr :renders

    #
    #attr :parts

    # Rendered output.
    #attr :content

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

    #
    def name
      @name ||= file.chomp(File.extname(file))
    end

    #
    def url
      @url ||= File.join(site.url, name + extension)
    end

    #
    def path
      @path ||= '/' + name + extension
    end

    #
    def output
      @output ||= File.basename(file).chomp(File.extname(file)) + extension
    end

    #
    def output=(fname)
      @output = File.join(File.dirname(file), fname) if fname
      @output
    end

    # DEPRECATE: Get rid of this and use rack to test page instead of files.
    # OTOH, that may not alwasy be possible we may need to keep this.
    def root
      '../' * file.count('/')
    end

    #
    def work
      '/' + File.dirname(file)
    end

    # Summary is the rendering of the first part.
    def summary
      @summary #||= @renders.first
    end

    # TODO
    #def next
    #  self
    #end

    # TODO
    #def previous
    #  self
    #end

    #
    def dryrun?
      site.dryrun
    end

    #
    def to_h
      attributes.merge(
        'url'      => url,
        'path'     => path,
        'summary'  => summary
        #'yield'    => content
      )
    end

    # Convert pertinent information to a Hash to be used in rendering.
    def to_contextual_attributes
      to_h.merge(
        'site'=>site.to_h, 'page'=>to_h, 'root'=>root, 'work'=>work, 'project'=>site.project
      )
    end

    #
    #def to_liquid
    #  to_contextual_attributes
    #end

    #
    def save(dir=nil)
      dir   = dir || Dir.pwd  # TODO
      text  = render
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

    #--
    # TODO: Improve this code in general, what's up with output vs. content?
    #++
    def render(inherit={}, &body)
      attributes = to_contextual_attributes
      attributes = attributes.merge(inherit)

      context = Context.new(attributes)
      render = @template.render(context, &body)
      output = render.to_s

      # To get the first rendered part.
      # TODO: make part of Neapolitan
      @summary = @attributes[summary] = render.summary

      #attributes['content'] = content if content
      #@renders = parts.map{ |part| part.render(stencil, attributes) }
      #output = @renders.join("\n")
      #@content = output

      #attributes = attributes.merge('content'=>output)

      if layout
        renout = site.lookup_layout(layout)
        raise "No such layout -- #{layout}" unless renout
        output = renout.render(attributes){ output }
      end

      output.strip
    end

    # TODO: Should validate front matter before any processing.
    def parse
      @template   = Neapolitan.file(file, :stencil=>'erb')
      @attributes = @template.header

      self.output    = @attributes.delete('output')
      self.layout    = @attributes.delete('layout')
      #self.stencil  = @attributes.delete('stencil') || site.defaults.stencil
      self.extension = @attributes.delete('extension')

      @attributes['author']    ||= 'Anonymous'
      @attributes['date']      ||= (date_from_filename(file) || Time.now)

      @attributes['title']     ||= nil
      @attributes['category']  ||= nil
      @attributes['summary']   ||= nil

      @attributes['tags'] = parse_tags(@attributes['tags'])
    end

    #
    def date_from_filename(file)
      if md = (/^\d\d\d\d-\d\d-\d\d/.match(file))
        md[1]
      end
    end

    #
    def parse_tags(entry)
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
      entry.map{ |e| e.strip }
    end

    # Default layout is different for pages vs. posts, so we
    # use this method to differntiation them.
    def default_layout
      site.defaults.pagelayout
    end

    #
    def to_s
      file
    end

    #
    def inspect
      "<#{self.class}: #{file}>"
    end

=begin
    #
    def parse
      hold = []
      text = File.read(file)
      sect = text.split(/^\-\-\-/)

      if sect.size == 1
        @prop = {}
        @parts << Part.new(sect[0], site.defaults.format)
      else
        void = sect.shift
        head = sect.shift
        head = YAML::load(head)

        parse_header(head)

        sect.each do |body|
          index   = body.index("\n")
          format  = body[0...index].strip
          format  = site.defaults.format if format.empty?
          text    = body[index+1..-1]
          @parts << Part.new(text, format)
        end
      end

    end

    #
    def parse_header(head)
      @stencil    = head['stencil'] || site.defaults.stencil
      @author     = head['author']  || 'Anonymous'
      @title      = head['title']
      @date       = head['date']
      @category   = head['category']
      @extension  = head['extension']
      @summary    = head['summary']

      self.tags   = head['tags']
      self.layout = head['layout']
    end
=end

  end

end

