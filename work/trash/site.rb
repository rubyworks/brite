require 'brite/config'
require 'brite/page'
require 'brite/post'
require 'brite/layout'

#
module Brite

  # Site class
  class Site

    # Location of site in local file system.
    attr :location

    # Location of output directory. This path will be prefixed to path of
    # generated files. By default this is the current working directory.
    attr :output

    # Array of layouts.
    attr :layouts

    # Array of ordinary pages.
    attr :pages

    # Array of  posts.
    attr :posts

    # If +true+ dont' actuall write files to disk.
    attr :dryrun

    # Trace execution, providing details on $stderr, about what is
    # transpiring as the site is being generated.
    attr :trace

    def initialize(options={})
      @location = options[:location] || Dir.pwd
      @output   = options[:output]   || Dir.pwd
      @dryrun   = options[:dryrun]
      @trace    = options[:trace]

      @layouts = []
      @pages   = []
      @posts   = []
    end

    # Returns an Array of all tags used in all posts.
    def tags
      @tags ||= posts.map{ |post| post.tags }.flatten.uniq.sort
    end

    # Returns a Hash posts indexed by tag.
    def posts_by_tag
      @posts_by_tag ||= (
        chart ||= Hash.new{|h,k|h[k]=[]}
        posts.each do |post|
          post.tags.each do |tag|
            chart[tag] << post
          end
        end
        chart
      )
    end

    #
    def trace?
      @trace
    end

    # DEPRECATE: replaced by trace?
    def verbose?
      @trace
    end

    # Build site.
    def build
      Dir.chdir(location) do
        sort_files
        if trace?
          puts "Layouts: " + layouts.join(", ")
          puts "Pages:   " + pages.join(", ")
          puts "Posts:   " + posts.join(", ")
          puts
        end
        render
        puts "#{pages.size + posts.size} Files: #{pages.size} Pages, #{posts.size} Posts"
      end
    end

    # Lookup layout file by name.
    def lookup_layout(name)
      layouts.find{ |layout| name == layout.name }
    end

    #
    def sort_files
      files = Dir['**/*']
      files.each do |file|
        temp = false
        name = File.basename(file)
        ext  = File.extname(file)
        case ext
        when '.layout'
          layouts << Layout.new(self, file)
        when '.page' #*%w{.markdown .rdoc .textile .whtml}
          pages << Page.new(self, file)
        when '.post'
          posts << Post.new(self, file)
        end
      end
      posts.sort!{ |a,b| b.date <=> a.date }
    end

    # Render and save site.
    def render
      render_posts  # render posts first, so pages can use them
      render_pages
    end

    # Render and save posts.
    def render_posts
      posts.each do |post|
        post.save(output)
      end
    end

    # Render and save pages.
    def render_pages
      pages.each do |page|
        page.save(output)
      end
    end

    # Access to configuration file data.
    def config
      @config ||= Config.new
    end

    # URL of site as set in configuration file.
    def url
      config.url
    end

    # Returns and instance of Gem::Do::Project.
    #--
    # TODO: incorporate location
    #++
    def project
      @project ||= Gemdo::Project.new
    end

    #
    def defaults
      config.defaults
    end

    # Convert pertinent information to a Hash to be used in rendering.
    def to_h
      pbt = {}
      posts_by_tag.each do |tag, posts|
        pbt[tag] = posts.map{ |p| p.to_h }
      end
      {
        'posts' => posts.map{ |p| p.to_h },
        'posts_by_tag' => pbt, #posts_by_tag, #.map{ |t, ps| [t, ps.map{|p|p.to_h}] }
        'tags' => tags,
        'url' => url
      }
    end

    # Conversion method provide support for the Liquid template engine. However,
    # at this  time Brite is standardizing on ERB, since it is more versitle.
    # So this method may be deprecated in the future.
    def to_liquid
      to_h
    end

  end

end
