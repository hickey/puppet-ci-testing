require 'rake'
require 'rake-version'
require 'rspec/core/rake_task'

#task :spec    => ['spec:all']
task :default => [:spec]

RakeVersion::Tasks.new

desc 'Run the spec tests.'
RSpec::Core::RakeTask.new do |t|
  t.pattern = 'spec/**/*_spec.rb'
end

#namespace :spec do
#  puts "in spec"
#  targets = ['./spec']
#  Dir.glob('./spec/*').each do |dir|
#    puts "discovered #{dir}"
#    next unless File.directory?(dir)
#    targets << File.basename(dir)
#    puts "Added #{target}"
#  end
#
#  task :all     => targets
#  task :default => :all
#
#  targets.each do |target|
#    desc "Run serverspec tests to #{target}"
#    RSpec::Core::RakeTask.new(target.to_sym) do |t|
#      puts "new task"
#      ENV['TARGET_HOST'] = target
#      t.pattern = "spec/#{target}/*_spec.rb"
#    end
#  end
#end


#Rake::VersionTask.new do |task|
#  task.with_git_tag = true
#end
