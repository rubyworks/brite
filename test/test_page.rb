require 'helper'

testcase Brite::Page do

  before do
    @site ||= Brite::Site.new('test/fixture')
  end

  method :permalink do

    test "permalink is calculated correctly" do
      page = @site.pages.first
      page.permalink.assert == '/example-page.html'
    end

  end

  method :layout do

    test "default layout is given" do
      page = @site.pages.first
      page.layout.assert == 'page'
    end

  end

end

