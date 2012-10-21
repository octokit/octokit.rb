module Octokit
  class Client
    module Contents

  # Receive the default Readme for a repository
  #
  # @param repo [String, Repository, Hash] A GitHub repository
  # @param ref [String] The String name of the Commit/Branch/Tag. Defaults to “master”.
  # @option options [String] :ref name of the Commit/Branch/Tag. Defaults to “master”.
  # @param media_type [Symbol] Media type to return
  # @return [Hash] The detail of the readme
  # @see http://developer.github.com/v3/repos/contents/
  # @example Get the readme file for a repo
  #   Octokit.readme("pengwynn/octokit")
  def readme(repo, options={}, media_type=:json)
    get("repos/#{Repository.new repo}/readme", options, 3, true, false, false, media_type)
  end

  # Receive a listing of a repository folder or the contents of a file
  #
  # @param repo [String, Repository, Hash] A GitHub repository
  # @option options [String] :path A folder or file path
  # @option options [String] :ref name of the Commit/Branch/Tag. Defaults to “master”.
  # @param media_type [Symbol] Media type to return
  # @return [Hash] The contents of a file or list of the files in the folder
  # @see http://developer.github.com/v3/repos/contents/
  # @example List the contents of lib/octokit.rb
  #   Octokit.contents("pengwynn/octokit", :path => 'lib/octokit.rb')
  def contents(repo, options={}, media_type=:json)
    repo_path = options.delete :path
    url = "repos/#{Repository.new repo}/contents/#{repo_path}"
    get(url, options, 3, true, false, false, media_type)
  end

  # This method will provide a URL to download a tarball or zipball archive for a repository.
  #
  # @param repo [String, Repository, Hash] A GitHub repository.
  # @option options format [String] Either tarball (default) or zipball.
  # @option options [String] :ref Optional valid Git reference, defaults to master.
  # @return [String] Location of the download
  # @see http://developer.github.com/v3/repos/contents/
  # @example Get archive link for pengwynn/octokit
  #   Octokit.archive_link("pengwynn/octokit")
  def archive_link(repo, options={})
    repo_ref = options.delete :ref
    format = (options.delete :format) || 'tarball'
    url = "repos/#{Repository.new repo}/#{format}/#{repo_ref}"
    headers = get(url, options, 3, false, true).headers
    return headers['location']
  end
  end
end
end
