module BindIt
  
  class JarLoader
    
    # Configuration options.
    class << self
      # An array of flags to pass to the JVM machine.
      attr_accessor :jvm_args
      # A log file to send JVM output to.
      attr_accessor :log_file
    end
    
    # Default configuration options.
    self.jvm_args = []
    self.log_file = nil
  
    # Load a JAR through Jruby/Rjb.
    def self.load(jar, path)
      if !::File.readable?(path + jar)
        raise "Could not find JAR file (looking in #{jar})."
      end
      if RUBY_PLATFORM =~ /java/
        set_java_logging if self.log_file
        load_jar_jruby(jar,path)
      else
        load_jar_rjb(jar,path)
      end
    end
    
    # Load a Jruby jar.
    def self.load_jar_jruby(jar, path)
      require path + jar
    end
    
    # Laad an Rjb jar.
    def self.load_jar_rjb(jar,path)
      self.init_rjb unless ::Rjb::loaded?
      jar = path + jar
      ::Rjb::add_jar(jar)
    end
    
    # Load Rjb and create Java VM.
    def self.init_rjb
      ::Rjb::load(nil, self.jvm_args)
      set_java_logging if self.log_file
    end

    # Redirect the output of the JVM to log.
    def self.set_java_logging
      system, print_stream, file = nil, nil, nil
      if RUBY_PLATFORM =~ /java/
        system = java.lang.System
        print_stream = java.io.PrintStream
        file = java.io.File
      else
        system = Rjb::import('java.lang.System')
        print_stream = Rjb::import('java.io.PrintStream')
        file = Rjb::import('java.io.File')
      end
      ps = print_stream.new(file.new(self.log_file))
      ps.write(::Time.now.strftime("[%m/%d/%Y at %I:%M%p]\n\n"))
      system.setOut(ps)
      system.setErr(ps)
    end

  end
  
end