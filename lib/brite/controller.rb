require 'neapolitan'
require 'brite/config'
require 'brite/layout'
require 'brite/models/site'
require 'brite/models/page'
require 'brite/models/post'

module Brite

  # The Controller class is the primary Brite class, handling
  # the generation of site files.
  #
  class Controller

    # New Controller.
    #
    # @param [Hash] options
    #   Controller options.
    #
    # @option options [String] :location
    #   Location of brite project.   
    #
    # @option options [String] :output
    #   Redirect all output to this directory.
    #
    def initialize(options={})
      @location = options[:location] || Dir.pwd
      @output   = options[:output]
      #@dryrun   = options[:dryrun]
      #@trace    = options[:trace]

      @site = Site.new(location, :url=>options[:url])
    end

    # Returns an instance of Site.
    attr :site

    # Directory of site files on disk.
    attr :location

    # Where to save results. Usually the templates are shadowed, which means
    # the ouput is the same a location.
    attr :output

    ## Returns an Array of Layouts.
    #def layouts
    #  @site.layouts
    #end

    # Access to configuration file data.
    def config
      site.config
    end

    # URL of site as set in initializer or configuration file.
    def url
      site.url
    end

    # Is `dryrun` mode on? Checks the global variable `$DRYRUN`.
    def dryrun?
      $DRYRUN #@dryrun
    end

    # Is `trace` mode on? Checks global variable `$TRACE`.
    def trace?
      $TRACE #@trace
    end

    # Build the site.
    def build
      if trace?
        puts "Layouts: " + site.layouts.map{ |layout| layout.name }.join(", ")
        puts "Pages:   " + site.pages.map{ |page| page.file }.join(", ")
        puts "Posts:   " + site.posts.map{ |post| post.file }.join(", ")
        puts
      end

      Dir.chdir(location) do
        site.posts.each do |post|
          puts "Rendering #{post.file}" if $DEBUG
          save(post)
        end
        site.pages.each do |page|
          puts "Rendering #{page.file}" if $DEBUG
          save(page)
        end
      end
      puts "\n#{site.pages.size + site.posts.size} Files: #{site.pages.size} Pages, #{site.posts.size} Posts"
    end

    # Save page/post redering to disk.
    #
    # @param [Model] model
    #   The {Page} or {Post} to save to disk.
    #
    def save(model)
      file = output ? File.join(output, model.output) : model.output
      text = model.to_s

      if File.exist?(file)
        current = File.read(file)
      else
        current = nil
      end

      if current != text or $FORCE
        if dryrun?
          puts "    dry run: #{file}"
        else
          puts "      write: #{file}"
          File.open(file, 'w'){ |f| f << text }
        end
      else
        puts "  unchanged: #{file}"
      end
    end

  end

end
