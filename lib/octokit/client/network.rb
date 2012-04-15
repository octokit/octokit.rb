module Octokit
  class Client
    module Network
      def network_meta(repo, options={})
        warn 'DEPRECATED: V3 of the API does not support this information. Support will be removed soon.'
        get("/#{Repository.new(repo)}/network_meta", options, 2, false)
      end

      def network_data(repo, options={})
        warn 'DEPRECATED: V3 of the API does not support this information. Support will be removed soon.'
        get("/#{Repository.new(repo)}/network_data_chunk", options, 2, false)['commits']
      end
    end
  end
end
