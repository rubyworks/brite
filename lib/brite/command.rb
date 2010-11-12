require 'optparse'
require 'brite/controller'

module Brite

  # Initialize and run Command.
  def self.cli(*argv)
    Command.new(*argv).call
  end

  # Webrite command line interface.
  class Command

    # New Command.
    def initialize(*argv)
      @output   = nil #@argv.shift
      @url      = nil
      @dryrun   = false
      @trace    = false

      parser.parse!(argv)

      @location = argv.shift || '.'
    end

    # Returns an OptionParser instance.
    def parser
      OptionParser.new do |opt|
        opt.on("--url URL", "site URL") do |url|
          @url = url
        end

        opt.on("--trace", "show extra operational information") do
          @trace = true
        end

        opt.on("--dryrun", "-n", "don't actually write to disk") do
          @dryrun = true
        end

        opt.on("--force", "force overwrites") do
          $FORCE = true
        end

        opt.on("--debug", "run in debug mode") do
          $DEBUG   = true
        end

        opt.on("--warn", "show Ruby warnings") do
          $VERBOSE = true
        end

        opt.on_tail("--help", "display this help message") do
          puts opt
          exit
        end
      end
    end

    #
    def call
      begin
        controller.build
      rescue => e
        $DEBUG ? raise(e) : puts(e.message)
      end
    end

    def controller
      Controller.new(
        :location => @location,
        :output   => @output,
        :url      => @url,
        :dryrun   => @dryrun,
        :trace    => @trace
      )
    end

  end

end

