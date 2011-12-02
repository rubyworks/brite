require 'fileutils'
require 'optparse'
require 'rack/server'
require 'rack/handler'
require 'rack/builder'
require 'rack/directory'
require 'rack/file'

module Brite

  # Brite::Server is a Rack-based server useful for testing sites locally.
  # not all sites --in fact, most sites, can not be fully previewed via
  # static files. A webserver is required to render and navigate a site
  # completely. So this light server is provided to facilitate this.
  class Server < ::Rack::Server

    class Options
      def parse!(args)
        args, options = args.dup, {}

        opt_parser = OptionParser.new do |opts|
          opts.banner = "Usage: brite-server [options]"

          opts.on("-p", "--port=port", Integer,
                  "Runs server on the specified port.", "Default: 3000") { |v| options[:Port] = v }

          opts.on("-b", "--binding=ip", String,
                  "Binds server to the specified ip.", "Default: 0.0.0.0") { |v| options[:Host] = v }

          opts.on("-c", "--config=file", String,
                  "Use custom rackup configuration file.") { |v| options[:config] = v }

          opts.on("-d", "--daemon", "Make server run as a Daemon.") { options[:daemonize] = true }

          opts.on("-u", "--debugger", "Enable ruby-debugging for the server.") { options[:debugger] = true }

          opts.on("-e", "--environment=name", String,
                  "Specifies the environment to run this server under (test/development/production).",
                  "Default: development") { |v| options[:environment] = v }

          opts.separator ""

          opts.on_tail("-h", "--help", "Show this help message.") { puts opts; exit }
        end

        opt_parser.parse!(args)

        options[:server] = args.shift

        return options
      end
    end

    #
    def initialize(*)
      super
      set_environment
    end

    #
    def opt_parser
      Options.new
    end

    #
    def set_environment
      ENV["BRITE_ENV"] ||= options[:environment]
    end

    #
    def start
      puts "=> Booting #{server}"
      puts "=> On http://#{options[:Host]}:#{options[:Port]}"
      puts "=> Call with -d to detach" unless options[:daemonize]
      trap(:INT) { exit }
      puts "=> Ctrl-C to shutdown server" unless options[:daemonize]

      #Create required tmp directories if not found
      %w(cache pids sessions sockets).each do |dir_to_make|
        FileUtils.mkdir_p(File.join('.cache', dir_to_make))
      end

      super
    ensure
      # The '-h' option calls exit before @options is set.
      # If we call 'options' with it unset, we get double help banners.
      puts 'Exiting' unless @options && options[:daemonize]
    end

    def middleware
      middlewares = []
      #middlewares << [Rails::Rack::LogTailer, log_path] unless options[:daemonize]
      #middlewares << [Rails::Rack::Debugger]  if options[:debugger]
      Hash.new(middlewares)
    end

    def log_path
      ".cache/brite.log"
    end

    def default_options
      super.merge({
        :Port        => 3000,
        :environment => (ENV['BRITE_ENV'] || "development").dup,
        :daemonize   => false,
        :debugger    => false,
        :pid         => ".cache/pids/server.pid",
        :config_file => nil
      })
    end

    #
    def root
      Dir.pwd
    end

    def app
      @app ||= begin
        config_file = options[:config_file]
        if config_file && ::File.exist?(config_file)
          app, options = Rack::Builder.parse_file(config_file, opt_parser)
          self.options.merge!(options)
          app
        else
          root = self.root
          app, options = Rack::Builder.new do
            run Rack::Directory.new("#{root}")
          end
          #self.options.merge!(options)
          app
        end
      end
    end

  end

end

## The static content rooted in the current working directory
## Eg. Dir.pwd =&gt; http://0.0.0.0:3000/
#root = Dir.pwd
#puts ">>> Serving: #{root}"
#run Rack::Directory.new("#{root}")

