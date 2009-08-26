require 'brite/site'

module Brite

  # Webrite command line interface.

  class Command

    def self.start
      new.start
    end

    def initialize(argv=nil)
      @argv ||= ARGV.dup

      @noharm = @argv.delete('--dryrun') || @argv.delete('--noharm')
      @trace  = @argv.delete('--trace')

      @argv.reject!{ |e| e =~ /^-/ }

      @location = @argv.shift || '.'
      #@output = @argv.shift
    end

    #
    def start
      begin
        site.build
      rescue => e
        @trace ? raise(e) : puts(e.message)
      end
    end

    def site
      Site.new(
        :location => @location,
        :output   => @output,
        :noharm   => @noharm,
        :trace    => @trace
      )
    end
  end

  #
  # Command to generate a single part to standard out.
  #

  class PartCommand

    def self.start
      new.start
    end

    def initialize(argv=nil)
      @argv ||= ARGV.dup
    end

    def start
      render(parts)
    end

    # render a single part to stdout.

    def render(parts)
      $stdout << Page.new(parts).to_html
    end

  private

    def parts
      parts = []
      @argv.each do |x|
        if /^-/ =~ x
          parts << [x.sub(/-{1,2}/,'')]
        else
          parts.last < x
        end
      end
      Hash[*parts]
    end

  end

end

