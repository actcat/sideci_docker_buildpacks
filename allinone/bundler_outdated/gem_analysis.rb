#!/usr/bin/env ruby
require File.expand_path('../../bundler_outdated/side_ci/gemfile.rb', __FILE__)

begin
  case ARGV[0]
  when "--version", "-v"
    puts "bundler_outdated version 0.1.0"
  else
    gemfile_dir = File::expand_path(ARGV[0])
    output_file = File::expand_path(ARGV[1])

    options          = {}
    options[:strict] = false

    Dir.chdir(gemfile_dir) {
      gemfile         = SideCi::Gemfile.new(gemfile_dir)
      gemfile.options = options
      gemfile         = gemfile.analysis!
      gemfile.write_analysis_data(output_file)
    }
  end
rescue SideCi::GemfileLockNotExistsError => e
  $stderr.puts 'Gemfile.lock is not exists'
end
