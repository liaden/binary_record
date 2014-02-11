require "bundler/gem_tasks"

task :console do
  require 'irb'
  require 'irb/completion'
  require 'binary_record'
  ARGV.clear
  IRB.start
end

task :pry do
  require 'pry'
  require 'binary_record'
  ARGV.clear
  Pry.start
end
