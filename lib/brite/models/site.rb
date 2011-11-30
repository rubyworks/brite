require 'brite/models/model'

module Brite

  #
  class Site < Model

    # New Site model.
    def initialize(settings={})
      settings.each do |k,v|
        __send__("#{k}=", v)
      end
      @pages = []
      @posts = []
    end

    # Returns a String of the site's URL.
    attr_accessor :url

    # Returns and Array of Page instances.
    attr :pages

    # Returns and Array of Post instances.
    attr :posts

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
    def inspect
      "#<Brite::Site @url=#{url.inspect}>"
    end

  end

end
