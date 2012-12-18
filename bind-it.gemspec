# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)

require 'bind-it'

Gem::Specification.new do |s|
  s.name        = 'bind-it'
  s.version     = BindIt::VERSION
  s.authors     = ['Louis Mullie']
  s.email       = ['louis.mullie@gmail.com']
  s.homepage    = 'https://github.com/louismullie/bind-it'
  s.summary     = %q{ BindIt is a tool to facilitate the creation of Java bindings in Ruby. }
  s.description = %q{ BindIt is a thin wrapper over the Ruby-Java-Bridge (Rjb) to facilitate the creation of Java bindings in Ruby. }
  
  # Add all files.
  s.files = Dir['lib/**/*'] + Dir['bin/**/*'] + ['README.md', 'LICENSE']
  
  # Runtime dependencies
  
  if RUBY_PLATFORM =~ /java/
    s.platform = 'java'
  else
    s.add_runtime_dependency 'rjb'
  end
      
end