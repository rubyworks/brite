require 'fileutils'
require 'tmpdir'
require 'optparse'

require 'rack'
require 'rack/server'
require 'rack/handler'
require 'rack/builder'
require 'rack/directory'
require 'rack/file'

require 'brite/config'

module Brite

  # Brite::Server is a Rack-based server useful for testing sites locally.
  # Most sites cannot be fully previewed by loading static files into a browser.
  # Rather, a webserver is required to render and navigate a site completely. 
  # So this light server is provided to facilitate this.
  #
  class Server 

    #
    def self.start(argv)
      new(argv).start
    end

    #
    def initialize(argv)
      @options = ::Rack::Server::Options.new.parse!(argv)

      @options[:app] = app
      @options[:pid] = "#{tmp_dir}/pids/server.pid"

      @options[:Port] ||= '3000'
    end

    # THINK: Should we be using a local tmp directory instead?

    # Temporary directory used by the rack server.
    def tmp_dir
      @tmp_dir ||= File.join(Dir.tmpdir, 'brite', root)
    end

    def start
      ensure_brite_site

      # create required tmp directories if not found
      %w(cache pids sessions sockets).each do |dir_to_make|
        FileUtils.mkdir_p(File.join(tmp_dir, dir_to_make))
      end

      ::Rack::Server.start(@options)
    end

    def ensure_brite_site
      return true if File.exist?(rack_file)
      return true if config.file
      abort "Not a brite site."
    end

    #
    def config
      @config ||= Brite::Config.new(root)
    end

    #
    def root
      Dir.pwd
    end

    #
    def rack_file
     'brite.ru'
    end

    #
    def app
      @app ||= (
        if ::File.exist?(rack_file)
          app, options = Rack::Builder.parse_file(rack_file, opt_parser)
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
      )
    end

    #
    #def log_path
    #  "_brite.log"
    #end

    #
    #def middleware
    #  middlewares = []
    #  #middlewares << [Rails::Rack::LogTailer, log_path] unless options[:daemonize]
    #  #middlewares << [Rails::Rack::Debugger]  if options[:debugger]
    #  Hash.new(middlewares)
    #end

  end

end
