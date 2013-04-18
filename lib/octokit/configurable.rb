module Octokit
  module Configurable
    attr_accessor :api_endpoint, :auto_paginate, :client_id, :default_media_type, :connection_options, 
                  :login, :middleware, :per_page, :proxy, :user_agent, :web_endpoint
    attr_writer :access_token, :client_secret, :password

    class << self

      def keys
        @keys ||= [
          :access_token,
          :api_endpoint,
          :auto_paginate,
          :client_id,
          :client_secret,
          :connection_options,
          :default_media_type,
          :login,
          :middleware,
          :per_page,
          :password,
          :proxy,
          :user_agent,
          :web_endpoint
        ]
      end
    end

    def configure
      yield self
    end

    def reset!
      Octokit::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", Octokit::Default.options[key])
      end
      self
    end
    alias setup reset!

    private

    def options
      Hash[Octokit::Configurable.keys.map{|key| [key, instance_variable_get(:"@#{key}")]}]
    end
  end
end
