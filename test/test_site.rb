require 'helper'

testcase Brite::Site do

  method :config do

    test "site instance has access to config instance" do
      site = Brite::Site.new('test/fixture')
      site.config.assert.is_a?(Brite::Config)
    end

  end

  method :pages do

    test "site should have a list of pages" do
      site = Brite::Site.new('test/fixture')
      site.pages.assert.is_a?(Array)
      site.pages.size.assert == 1
      site.posts.first.assert.is_a?(Brite::Page)
    end

  end

  method :posts do

    test "site should have a list of posts" do
      site = Brite::Site.new('test/fixture')
      site.posts.assert.is_a?(Array)
      site.posts.size.assert == 1
      site.posts.first.assert.is_a?(Brite::Post)
    end

  end

end

