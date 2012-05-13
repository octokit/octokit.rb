module Octokit
  class Client
    module Gists

      def create_gist(options={})
        post '/gists', options, 3
      end

      def delete_gist(gist, options={})
        response = delete("/gists/#{Gist.new gist}", options, 3, true, true)
        response.status == 204
      end

      def edit_gist(gist, options={})
        patch "/gists/#{Gist.new gist}", options, 3
      end

      def gist(gist, options={})
        get "/gists/#{Gist.new gist}", options, 3
      end

      def gists(username=nil, options={})
        if username.nil?
          get '/gists', options, 3
        else
          get "/users/#{username}/gists", options, 3
        end
      end

      # Returns +true+ if +gist+ is starred, +false+ otherwise.
      def gist_starred?(gist, options={})
        begin
          get("/gists/#{Gist.new gist}/star", options, 3, true, true)
          return true
        rescue Octokit::NotFound
          return false
        end
      end

      def fork_gist(gist, options={})
        post "/gists/#{Gist.new gist}/fork", options, 3
      end

      def public_gists(options={})
        get '/gists', options, 3
      end

      def starred_gists(options={})
        get '/gists/starred', options, 3
      end

      # Returns +true+ or +false+ based on success.
      def star_gist(gist, options={})
        response = put("/gists/#{Gist.new gist}/star", options, 3, true, true)
        response.status == 204
      end

      # Returns +true+ or +false+ based on success.
      def unstar_gist(gist, options={})
        response = delete("/gists/#{Gist.new gist}/star", options, 3, true, true)
        response.status == 204
      end

    end
  end
end
