module Octokit
  class Client
    module Network

      def network_meta(repo, options={})
        get("#{Repository.new(repo)}/network_meta", options, false, false)
      end

      def network_data(repo, options={})
        get("#{Repository.new(repo)}/network_data_chunk", options, false, false)['commits']
      end

    end
  end
end
