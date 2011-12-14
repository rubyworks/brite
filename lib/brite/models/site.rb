require 'brite/models/model'

module Brite

  #
  class Site < Model

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
          when '.page' #*%w{.markdown .rdoc .textile .whtml}
            page = load_page(file)
            if page.draft
            else
              @pages << page
            end
          when '.post'
            post = load_post(file)
            if post.draft
            else
              @posts << post
            end
          end
        end
      end

      @posts.sort!{ |a,b| b.date <=> a.date }
    end

    # TODO: Limit Neapolitan to Markup formats only ?

    # Returns an instance of Page.
    def load_page(file)
      Page.new(self, file)

      #template = Neapolitan.file(file, :stencil=>config.stencil)
      #settings = template.metadata #header

      ##settings['layout'] ||= config.page_layout

      #settings[:site] = self
      #settings[:file] = file

      #Page.new(settings){ |page| render(template, page) }
    end

    # Returns an instance of Post.
    def load_post(file)
      Post.new(self, file)

      #template = Neapolitan.file(file, :stencil=>config.stencil)
      #settings = template.header

      ##settings['layout'] ||= config.post_layout

      #settings[:site] = self
      #settings[:file] = file

      #Post.new(settings){ |post| render(template, post) }
    end

    #
    #
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
      layout = layouts.find do |layout|
        config.layout_path.any? { |path|
          File.join(path, name) == layout.name 
        } or name == layout.name
      end
      layout
    end

  end

end
