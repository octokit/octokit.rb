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
  require_relative "lib/open_api_client_generator"
  api = OpenAPIClientGenerator::API.at(OasParser::Definition.resolve("../routes/openapi/api.github.com/index.json"))
  File.open("lib/octokit/client/deployments.rb", "w") do |f|
    f.puts api.to_s
  end
end
