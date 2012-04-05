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
      
    # Load Rjb and create Java VM.
    def self.init
      ::Rjb::load(nil, self.jvm_args)
      set_java_logging if self.log_file
    end
    
    # Redirect the output of the JVM to log.
    def self.set_java_logging
      const_set(:System, Rjb::import('java.lang.System'))
      const_set(:PrintStream, Rjb::import('java.io.PrintStream'))
      const_set(:File2, Rjb::import('java.io.File'))
      ps = PrintStream.new(File2.new(self.log_file))
      ps.write(::Time.now.strftime("[%m/%d/%Y at %I:%M%p]\n\n"))
      System.setOut(ps)
      System.setErr(ps)
    end
    
    # Load a JAR through Rjb.
    def self.load(jar, path)
      self.init unless ::Rjb::loaded?
      jar = path + jar
      if !::File.readable?(jar)
        raise "Could not find JAR file (looking in #{jar})."
      end
      ::Rjb::add_jar(jar)
    end
    
  end
  
end
