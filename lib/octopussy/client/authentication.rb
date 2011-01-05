module Octopussy
  class Client
    module Authentication
      def authentication
        if login && token
          {:login => "#{login}/token", :password => token}
        elsif login && password
          {:login => login, :password => password}
        else
          {}
        end
      end

      def authenticated?
        !authentication.empty?
      end
    end
  end
end
