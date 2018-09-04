require 'rake/clean'
require 'rspec/core/rake_task'
require 'cloudspin/stack/rake'
require 'cloudspin/stack/artefact'

CLEAN.include('work')
CLEAN.include('build')
CLEAN.include('dist')
CLOBBER.include('state')

RSpec::Core::RakeTask.new(:spec)
task :default => :spec

namespace :stack do
  namespace 'codepipeline' do
    stack = Cloudspin::Stack::Rake::StackTask.new(id: 'codepipeline').instance

    Cloudspin::Stack::Rake::InspecTask.new(stack_instance: stack,
                                           inspec_target: 'aws://eu-west-1/assume-spin_stack_manager-skeleton')

    Cloudspin::Stack::Rake::ArtefactTask.new(definition_folder: './src',
                                             dist_folder: './dist')
  end
end

desc 'Create, test, and destroy the stack'
task :test => [
  :'stack:codepipeline:up',
  :'stack:codepipeline:inspec',
  :'stack:codepipeline:down'
]
