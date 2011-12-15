require 'brite/model'
#require 'brite/page'
#require 'brite/post'
#require 'brite/part'

module Brite

  # TODO: Limit Neapolitan to Markup formats only ?

  #
  class Site #< Model

    # New Site model.
    #
    # @param [String] location
    #   The directory of the site's files.
    #
    def initialize(location, options={})
      @location = location
      @config   = Config.new(location)

      options.each do |k,v|
        __send__("#{k}=", v)
      end

      @pages   = []
      @posts   = []
      @parts   = []
      @layouts = []

      @tags         = nil
      @posts_by_tag = nil

      load_site
    end

    #
    attr :location

    # Access to site configuration.
    attr :config

    # Returns and Array of Page instances.
    attr :pages

    # Returns and Array of Post instances.
    attr :posts

    #
    attr :parts

    #
    attr :layouts

    # Returns a String of the site's URL.
    def url
      @url ||= config.url
    end

    # Change site URL.
    attr_writer :url

    # Returns an Array of all tags used in all posts.
    def tags
      @tags ||= (
        list = []
        posts.each{ |post| list.concat(post.tags) }
        list.uniq.sort
      )
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
    def inspect
      "#<Brite::Site @url=#{url.inspect}>"
    end

   #private

    def load_site
      Dir.chdir(location) do
        files = Dir['**/*']
        files.each do |file|
          name = File.basename(file)
          ext  = File.extname(file)
          case ext
          when '.layout'
            layouts << Layout.new(self, file)
          when '.part'
            parts << Part.new(self, file)
          when '.page' #*%w{.markdown .rdoc .textile .whtml}
            page = Page.new(self, file)
            pages << page unless page.draft
          when '.post'
            post = Post.new(self, file)
            posts << post unless post.draft
          end
        end
      end

      @posts.sort!{ |a,b| b.date <=> a.date }
    end

    #
    #def page_defaults
    #  { :stencil => config.stencil,
    #    :layout  => config.layout,
    #    :author  => config.author
    #  }
    #end

  public

    #
    # Lookup layout by name.
    #
    def lookup_layout(name)
      layouts.find do |layout|
        config.layout_path.any? { |path|
          File.join(path, name) == layout.name 
        } or name == layout.name
      end
    end

    #
    #
    #
    def lookup_partial(name)
      parts.find do |part|
        config.partial_path.any? { |path|
          File.join(path, name) == part.name 
        } or name == part.name
      end
    end

  end

end
