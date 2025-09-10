class RetrospectiveSessionChannel < ApplicationCable::Channel
  def subscribed
    # Subscribe to updates for a specific retrospective session
    Rails.logger.info "ActionCable: Subscribing to session #{params[:session_id]}"
    Rails.logger.info "ActionCable: Current database connection: #{ActiveRecord::Base.connection.current_database}"
    Rails.logger.info "ActionCable: Solid Cable tables exist: #{ActiveRecord::Base.connection.table_exists?('solid_cable_messages')}"
    
    retrospective_session = RetrospectiveSession.find(params[:session_id])
    stream_for retrospective_session
    Rails.logger.info "ActionCable: Successfully subscribed to session #{retrospective_session.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    Rails.logger.info "ActionCable: Unsubscribed from session"
  end
end
