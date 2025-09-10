module ApplicationCable
  class Connection < ActionCable::Connection::Base
    # Allow connections from any origin in production
    # In a more secure setup, you'd want to restrict this to your domain
    def connect
      # Accept all connections for now
      # You can add authentication here if needed
    end
  end
end
