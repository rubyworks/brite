require 'optparse'
require 'brite/controller'

module Brite

  # Initialize and run Command.
  def self.cli(*argv)
    Command.call(*argv)
  end

  # Brite command module.
  module Command
    extend self

    # Execute command.
    #
    # @public
    def call(*argv)
      options = parse(argv)

      begin
        controller(options).build
      rescue => e
        $DEBUG ? raise(e) : puts(e.message)
      end
    end

    # Create an instance of Brite::Controller given controller options.
    #
    # @private
    #
    # @return [Controller] New controller instance.
    def controller(options)
      Controller.new(options)
    end

    # Parse controller options from command line arguments.
    #
    # @private
    #
    # @return [Hash] controller options
    def parse(argv)
      parser = OptionParser.new

      options = {
        :output => nil,
        :url    => nil
      }

      options_url     parser, options
      options_general parser, options
      options_help    parser, options

      parser.parse!(argv)

      options[:location] = argv.shift || '.'

      options
    end

    # Add `--url` option to command line parser.
    #
    # @param [OptionParser] parser
    #   An instance of option parser.
    #
    # @param [Hash] options
    #   An options hash to be passed to Controller.
    #
    # @private
    def options_url(parser, options)
      parser.on("--url URL", "website fully qualified URL") do |url|
        options[:url] = url
      end
    end

    # Add `--trace`, `--dryrun`, `--force`, `--debug` and `--warn` options
    # to command line interface. These are all "global" options which means
    # they set global variables if used.
    #
    # @param [OptionParser] parser
    #   An instance of option parser.
    #
    # @param [Hash] options
    #   An options hash to be passed to Controller.
    #
    # @private
    def options_general(parser, options)
      parser.on("--trace", "show extra operational information") do
        $TRACE = true
      end

      parser.on("--dryrun", "-n", "don't actually write to disk") do
        $DRYRUN = true
      end

      parser.on("--force", "force overwrites") do
        $FORCE = true
      end

      parser.on("--debug", "run in debug mode") do
        $DEBUG   = true
      end

      parser.on("--warn", "show Ruby warnings") do
        $VERBOSE = true
      end
    end

    # Add `--help` option to command line parser.
    #
    # @param [OptionParser] parser
    #   An instance of option parser.
    #
    # @param [Hash] options
    #   An options hash to be passed to Controller.
    #
    # @private
    def options_help(parser, options)
      parser.on_tail("--help", "display this help message") do
        puts opt
        exit
      end
    end

  end

end
