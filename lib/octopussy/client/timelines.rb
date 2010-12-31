module Octopussy
  class Client
    module Timelines

      def public_timeline(username=login, options={})
        if username.nil?
          path = "timeline.json"
        else
          path = "#{username}.json"
        end
        get(path, options, false, false)
      end

      def timeline(options={})
        get("#{login}.private.json", options, false, false)
      end

    end
  end
end
