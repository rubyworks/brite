require 'brite/models/page'

module Brite

  class Post < Page

    #
    def self.default_layout
      'post'
    end

    #
    attr_accessor :layout

    # This assumes `site.posts` is sorted by date.
    def previous_post
      @_previous_post ||= (
        index = site.posts.index(self)
        index < 0 ? nil : site.posts[index - 1]
      )
    end

    # This assumes `site.posts` is sorted by date.
    def next_post
      @_previous_post ||= (
        index = site.posts.index(self)
        site.posts[index + 1]
      )
    end

  end

end
