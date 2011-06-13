module Octokit
  class Client
    module PubSubHubBub

      #
      # Subscribe to a repository through pubsub
      #
      # @param owner [String] owner of mentioned repository
      # @param repository [String] repository name
      # @param service_name [String] service name owner
      # @param service_arguments [Hash] params that will be passed by subscibed hook.
      #    List of services is available @ https://github.com/github/github-services/tree/master/docs.
      #    Please refer Data node for complete list of arguments.
      # @example Subscribe to push events to one of your repositories to Travis-CI
      #    client = Octokit::Client.new(:oauth_token = "token")
      #    client.subscribe_service_hook('joshk', 'device_imapable', 'Travis', { :token => "test", :domain => "domain", :user => "user" })
      def subscribe_service_hook(owner, repository, service_name, service_arguments = {})
        topic = "https://github.com/#{owner}/#{repository}/events/push"
        callback = "github://#{service_name}?#{service_arguments.collect{ |k,v| [ k,v ].join("=") }.join("&") }"
        subscribe(topic, callback)
        true
      end

      #
      # Unsubscribe repository through pubsub
      #
      # @param owner [String] owner of mentioned repository
      # @param repository [String] repository name
      # @param service_name [String] service name owner
      #    List of services is available @ https://github.com/github/github-services/tree/master/docs.
      # @example Subscribe to push events to one of your repositories to Travis-CI
      #    client = Octokit::Client.new(:oauth_token = "token")
      #    client.unsubscribe_service_hook('joshk', 'device_imapable', 'Travis')
      def unsubscribe_service_hook(owner, repository, service_name)
        topic = "https://github.com/#{owner}/#{repository}/events/push"
        callback = "github://#{service_name}"
        unsubscribe(topic, callback)
        true
      end

      # Subscribe to a pubsub topic
      #
      # @param topic [String] A recoginized and supported pubsub topic
      # @param callback [String] A callback url to be posted to when the topic event is fired
      # @return [boolean] true if the subscribe was successful, otherwise an error is raised
      # @example Subscribe to push events from one of your repositories, having an email sent when fired
      #   client = Octokit::Client.new(:oauth_token = "token")
      #   client.subscribe("https://github.com/joshk/devise_imapable/events/push", "github://Email?address=josh.kalderimis@gmail.com")
      def subscribe(topic, callback)
        options = {
          :"hub.mode" => "subscribe",
          :"hub.topic" => topic,
          :"hub.callback" => callback,
        }
        post("/hub", options, 3, true, true, true)
        true
      end

      # Unsubscribe from a pubsub topic
      #
      # @param topic [String] A recoginized pubsub topic
      # @param callback [String] A callback url to be unsubscribed from
      # @return [boolean] true if the unsubscribe was successful, otherwise an error is raised
      # @example Unsubscribe to push events from one of your repositories, no longer having an email sent when fired
      #   client = Octokit::Client.new(:oauth_token = "token")
      #   client.unsubscribe("https://github.com/joshk/devise_imapable/events/push", "github://Email?address=josh.kalderimis@gmail.com")
      def unsubscribe(topic, callback)
        options = {
          :"hub.mode" => "unsubscribe",
          :"hub.topic" => topic,
          :"hub.callback" => callback,
        }
        post("/hub", options, 3, true, true, true)
        true
      end
    end
  end
end
