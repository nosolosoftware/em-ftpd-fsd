# encoding: utf-8

require 'bundler'
begin
  Bundler.setup(:default, :development, :test)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "em-ftpd-fsd"
  gem.homepage = "https://github.com/nanocity/em-ftpd-fsd"
  gem.license = "GPLv3"
  gem.summary = %Q{File System Driver for EM-FTPD server}
  gem.description = %Q{Very simple file system driver for EM-FTPD server; including common FTP commands, authentication and before and after operation hooks.}
  gem.email = "lciudad@nosolosoftware.biz"
  gem.authors = ["Luis Ciudad"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'yard'
YARD::Rake::YardocTask.new( :doc ) do |t|
  t.options = [ "-m", "markdown", "-r", "README.md" ]
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new( :spec )
