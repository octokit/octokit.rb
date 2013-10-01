major, minor, patch = RUBY_VERSION.split('.').map(&:to_i)

if (major == 1 && minor < 9) || (major == 1 && minor == 9 && patch < 2)
  # pull in backports
  require 'octokit/backports/uri'
end

module Octokit
  class Client

    # Methods for the PubSubHubbub API
    #
    # @see http://developer.github.com/v3/repos/hooks/#pubsubhubbub
    module PubSubHubbub

      # Subscribe to a pubsub topic
      #
      # @param topic [String] A recoginized and supported pubsub topic
      # @param callback [String] A callback url to be posted to when the topic event is fired
      # @return [Boolean] true if the subscribe was successful, otherwise an error is raised
      # @example Subscribe to push events from one of your repositories, having an email sent when fired
      #   client = Octokit::Client.new(:oauth_token = "token")
      #   client.subscribe("https://github.com/joshk/devise_imapable/events/push", "github://Email?address=josh.kalderimis@gmail.com")
      def subscribe(topic, callback)
        options = {
          :"hub.callback" => callback,
          :"hub.mode" => "subscribe",
          :"hub.topic" => topic
        }
        response = pub_sub_hubbub_request(options)

        response.status == 204
      end

      # Unsubscribe from a pubsub topic
      #
      # @param topic [String] A recoginized pubsub topic
      # @param callback [String] A callback url to be unsubscribed from
      # @return [Boolean] true if the unsubscribe was successful, otherwise an error is raised
      # @example Unsubscribe to push events from one of your repositories, no longer having an email sent when fired
      #   client = Octokit::Client.new(:oauth_token = "token")
      #   client.unsubscribe("https://github.com/joshk/devise_imapable/events/push", "github://Email?address=josh.kalderimis@gmail.com")
      def unsubscribe(topic, callback)
        options = {
          :"hub.callback" => callback,
          :"hub.mode" => "unsubscribe",
          :"hub.topic" => topic
        }
        response = pub_sub_hubbub_request(options)

        response.status == 204
      end

      # Subscribe to a repository through pubsub
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param service_name [String] service name owner
      # @param service_arguments [Hash] params that will be passed by subscribed hook.
      #    List of services is available @ https://github.com/github/github-services/tree/master/docs.
      #    Please refer Data node for complete list of arguments.
      # @example Subscribe to push events to one of your repositories to Travis-CI
      #    client = Octokit::Client.new(:oauth_token = "token")
      #    client.subscribe_service_hook('joshk/device_imapable', 'Travis', { :token => "test", :domain => "domain", :user => "user" })
      def subscribe_service_hook(repo, service_name, service_arguments = {})
        topic = "#{Octokit.web_endpoint}#{Repository.new(repo)}/events/push"
        callback = "github://#{service_name}?#{service_arguments.collect{ |k,v| [ k,v ].map{ |p| URI.encode_www_form_component(p) }.join("=") }.join("&") }"
        subscribe(topic, callback)
      end

      # Unsubscribe repository through pubsub
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param service_name [String] service name owner
      #    List of services is available @ https://github.com/github/github-services/tree/master/docs.
      # @example Subscribe to push events to one of your repositories to Travis-CI
      #    client = Octokit::Client.new(:oauth_token = "token")
      #    client.unsubscribe_service_hook('joshk/device_imapable', 'Travis')
      def unsubscribe_service_hook(repo, service_name)
        topic = "#{Octokit.web_endpoint}#{Repository.new(repo)}/events/push"
        callback = "github://#{service_name}"
        unsubscribe(topic, callback)
      end

      private

      def pub_sub_hubbub_request(options = {})
        # This method is janky, bypass normal stack so we don'tl
        # serialize request as JSON
        conn = Faraday.new(:url => @api_endpoint) do |http|
          http.headers[:user_agent] = user_agent
          if basic_authenticated?
            http.basic_auth(@login, @password)
          elsif token_authenticated?
            http.authorization 'token', @access_token
          end
          http.request  :url_encoded
          http.use Octokit::Response::RaiseError
          http.adapter  Faraday.default_adapter
        end

        response = conn.post do |req|
          req.url "hub"
          req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
          req.body = options
        end
      end
    end
  end
end
