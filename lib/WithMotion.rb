# -*- encoding : utf-8 -*-
require 'rake' unless defined? Rake
include Rake::DSL

unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end
 
Motion::Project::App.setup do |app|
	app.files << File.join(app.project_dir, 'stubs/stubs.rb')
  Dir.glob(File.join(File.dirname(__FILE__), 'WithMotion/*.rb')).each do |file|
    app.files.unshift(file)
  end
end

namespace :with do
  desc "Generates stubs/stubs.rb for the RubyMotion compiler"
  task :stubs do
    App.info "Generate", "WithMotion Stubs"
    generate_stubs
  end
end

desc "Same as 'with:stubs'"
task :with => 'with:stubs'

namespace :build do
  desc "Generate WithMotion stubs"
  task :simulator => :with

  desc "Generate WithMotion stubs"
  task :device => :with
end

def generate_stubs
  methods = Array.new
  rm_methods = Array.new

  App.config.files.each do |f|
    unless File.dirname(f) == File.join(File.dirname(__FILE__), 'WithMotion') || File.dirname(f) == './stubs'
      code = File.open(f).read
      methods += code.scan /.with\(.*\)/
    end
  end

  methods.each do |m|
    rm_methods << rm_method(m)
  end

  write_stubs(rm_methods.uniq)
end

def rm_method(m)
  args_string = m.sub(".with(", "").chomp(")")
  args = args_string.scan /\w*:/
  rm_string = ""
  
  unless args.count == 0
    rm_string = "initWith"
    args[0] = args[0][0].capitalize + args[0][1..-2]
    rm_string << args.shift << "(_"

    args.each do |a|
      rm_string << "," << a << "_"
    end

    rm_string << ")"
  end

  rm_string
end

def write_stubs(rm_methods)
  stubs_string = "module WithMotion\nclass Stubs\n"
  rm_methods.each do |m|
    stubs_string << "def " << m << " end\n"
  end
  stubs_string << "end\nend"
  File.write(File.join(App.config.project_dir, "stubs/stubs.rb"), stubs_string)
end