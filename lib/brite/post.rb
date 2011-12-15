require 'brite/page'

module Brite

  # Models a blog post. A post is essentially  the same as a page,
  # but carries a relatition with other posts that a page does not.
  #
  class Post < Page

    #
    def initialize_defaults
      super

      @route  = site.config.post_route
      @layout = site.config.post_layout #@site.config.find_layout(@site.config.post_layout)

      @previous_post = nil
      @next_post     = nil
    end

    # This assumes `site.posts` is sorted by date.
    #
    # @todo Rename to back_post.
    def previous_post
      @previous_post ||= (
        index = site.posts.index(self)
        index == 0 ? nil : site.posts[index - 1]
      )
    end

    # This assumes `site.posts` is sorted by date.
    def next_post
      @next_post ||= (
        index = site.posts.index(self)
        site.posts[index + 1]
      )
    end

  end

end
