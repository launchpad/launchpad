require 'rspec/core/rake_task'
require 'rubocop/rake_task'

task default: :spec

RuboCop::RakeTask.new(:spec)

RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = false
end
