require 'brite/page'

module Brite

  # The Post class is essentially the same as the Page class.
  class Post < Page

    def default_layout
      config.post_layout
    end

    # TODO
    def next
      #self
    end

    # TODO
    def previous
      #self
    end

    #def to_contextual_attributes
    #  { 'site' => site.to_h, 'post' => to_h }
    #end
  end

end

