module BindIt
  module Binding

    VERSION = '0.0.1'

    require 'rjb'
    require 'bind-it/jar_loader'
    require 'bind-it/proxy_decorator'

    def self.extended(base)
      super(base)
      base.module_eval do
        class << self
          # Whether the bindings are initialized or not.
          attr_accessor :initialized
          # The default path to look into for JARs.
          attr_accessor :jar_path
          # The flags for starting the JVM machine.
          attr_accessor :jvm_args
          # A file to redirect JVM output to.
          attr_accessor :log_file
          # The default JARs to load before anything.
          attr_accessor :default_jars
          # The default namespace to search for classes.
          attr_accessor :default_namespace
          # The default classes to load.
          attr_accessor :default_classes
        end
        self.jar_path = ''
        self.jvm_args = []
        self.log_file = nil
        self.default_namespace = 'java'
        self.default_classes = []
        self.initialized = false
      end
    end

    # Load the default JARs and classes.
    def init  
      unless self.initialized
        BindIt::JarLoader.log_file = self.log_file
        BindIt::JarLoader.jvm_args = self.jvm_args
        self.load_default_jars
        self.load_default_classes
      end
      self.initialized = true
    end

    # Load a JAR file.
    def load_jar(jar, path = nil)
      BindIt::JarLoader.load(jar, path)
    end

    # Load the JARs, looking in default path.
    def load_default_jars
      self.default_jars.each do |jar|
        file, path = *jar
        path ||= self.jar_path
        load_jar(jar, path)
      end
    end

    # Public function to load classes inside
    # the namespace. Make sure the default
    # JARs and classes are loaded before.
    def load_class(klass, base = nil, rename = nil)
      base ||= self.default_namespace
      self.init unless self.initialized
      self.load_klass(klass, base, rename)
    end
    
    # Create the Ruby classes corresponding to
    # the StanfordNLP core classes.
    def load_default_classes
      self.default_classes.each do |info|
        klass, base, rename = *info
        self.load_klass(klass, base, rename)
      end
    end
    
    # Private function to load classes.
    # Doesn't check if initialized.
    def load_klass(klass, base, name = nil)
      base += '.' unless base == ''
      name ||= klass
      const_set(name.intern,
      Rjb::import("#{base}#{klass}"))
    end
    
    # Utility function to CamelCase names.
    def camel_case(text)
      text.to_s.gsub(/^[a-z]|_[a-z]/) do |a|
        a.upcase
      end.gsub('_', '')
    end
    

  end

end
