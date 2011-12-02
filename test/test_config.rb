require 'helper'

testcase Brite::Config do

  method :location do

    test "config loads given location" do
      config = Brite::Config.new('test/fixture')
      config.assert.location == 'text/fixture'
    end

  end

  method :file do

    test "config find configuraiton file" do
      config = Brite::Config.new('test/fixture')
      config.file.assert == 'test/fixture/brite.yml'
    end

  end

end
