module Octokit
  class Client
    module Milestones

      def list_milestones(repository, options={})
        get("/repos/#{Repository.new(repository)}/milestones", options, 3)
      end
      alias :milstones :list_milestones

    end
  end
end
