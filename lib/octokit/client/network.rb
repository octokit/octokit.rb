module Octokit
  class Client
    module Network

      def network_meta(repo, options={})
        get("#{Repository.new(repo)}/network_meta", options, false, false)
      end
  
      def network_data(repo, nethash, options={})
        get("#{Repository.new(repo)}/network_data_chunk", options.merge({:nethash => nethash}), false, false)['commits']
      end

    end
  end
end
