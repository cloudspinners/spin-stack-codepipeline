require 'rake/clean'
require 'rspec/core/rake_task'
require 'cloudspin/stack/rake'
require 'cloudspin/stack/artefact'

CLEAN.include('work')
CLEAN.include('build')
CLEAN.include('dist')
CLOBBER.include('state')

include Cloudspin::Stack::Rake

stack = StackTask.new.instance
InspecTask.new(stack_instance: stack)
RSpec::Core::RakeTask.new(:spec)

ArtefactTask.new(definition_folder: './src',
                 dist_folder: './dist')

desc 'Create, test, and destroy the stack'
task :test => [
  :'stack:codepipeline:up',
  :'stack:codepipeline:inspec',
  :'stack:codepipeline:down'
]
