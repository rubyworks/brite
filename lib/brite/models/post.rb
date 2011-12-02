require 'brite/models/page'

module Brite

  class Post < Page

    # This assumes `site.posts` is sorted by date.
    def previous_post
      @_previous_post ||= (
        index = site.posts.index(self)
        index < 0 ? nil : site.posts[index - 1]
      )
    end

    # This assumes `site.posts` is sorted by date.
    def next_post
      @_next_post ||= (
        index = site.posts.index(self)
        site.posts[index + 1]
      )
    end

   private

    #
    def initialize_defaults
      @layout = @site.config.post_layout
      @slug   = @site.config.post_slug
      @author = @site.config.author
    end

  end

end
