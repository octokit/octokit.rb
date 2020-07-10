require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :test => :spec
task :default => :spec

namespace :doc do
  begin
    require 'yard'
    YARD::Rake::YardocTask.new do |task|
      task.files   = ['README.md', 'LICENSE.md', 'lib/**/*.rb']
      task.options = [
        '--output-dir', 'doc/yard',
        '--markup', 'markdown',
      ]
    end
  rescue LoadError
  end
end

desc "Generate the API client files based on the OpenAPI route docs."
task :generate do
  require_relative "lib/openapi_client_generator"
  OpenAPIClientGenerator::API.at(OasParser::Definition.resolve("../api.github.com-deref.json")) do |api|
    File.open("lib/octokit/client/#{api.resource}.rb", "w") do |f|
      f.puts api.to_s
    end
    `bundle exec rubocop -a lib/octokit/client/#{api.resource}.rb`
  end
end
