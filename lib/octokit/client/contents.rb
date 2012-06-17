module Octokit
	class Client
		module Contents

      # Receive the default Readme for a repository
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param ref [String] The String name of the Commit/Branch/Tag. Defaults to “master”.
      # @return [Hash] The detail of the readme
      # @see http://developer.github.com/v3/repos/contents/
      # @example Get the readme file for a repo
      #   Octokit.readme("pengwynn/octokit")
			def readme(repo, ref="master", options={})
				 parameters = {
          :ref  => ref,
        }
				get("/repos/#{Repository.new repo}/readme", options.merge(parameters), 3)
			end

      # Receive a listing of a repository folder or the contents of a file
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param path [String] A folder or file path
      # @param ref [String] The String name of the Commit/Branch/Tag. Defaults to “master”.
      # @return [Hash] The contents of a file or list of the files in the folder
      # @see http://developer.github.com/v3/repos/contents/
      # @example List the contents of /lib/octokit.rb
      #   Octokit.contents("pengwynn/octokit", 'lib/octokit.rb')
			def contents(repo, path="", ref="master", options={})
				parameters = {
          :ref  => ref,
        }
				get("/repos/#{Repository.new repo}/contents/#{path}", options.merge(parameters), 3)
			end
			
			# This method will provide a URL to download a tarball or zipball archive for a repository. 
      #
      # @param repo [String, Repository, Hash] A GitHub repository.
      # @param archive_format [String] Either tarball or zipball.
      # @param ref [String] Optional valid Git reference, defaults to master.
      # @return [Faraday::Utils::Headers] The header of the response.
      # @see http://developer.github.com/v3/repos/contents/
      # @example Get archive link for pengwynn/octokit
      #   Octokit.archive_link("pengwynn/octokit")
			def archive_link(repo, archive_format="tarball", ref="master", options={})
				get("/repos/#{Repository.new repo}/#{archive_format}/#{ref}", options, 3, false, true).headers
			end

		end
	end
end