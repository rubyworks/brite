require 'brite/models/page'

module Brite

  class Post < Page

    #
    attr_accessor :layout do
      'post'
    end

  end

end
