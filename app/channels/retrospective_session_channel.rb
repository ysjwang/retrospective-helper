class RetrospectiveSessionChannel < ApplicationCable::Channel
  def subscribed
    # Subscribe to updates for a specific retrospective session
    Rails.logger.info "ActionCable: Subscribing to session #{params[:session_id]}"
    retrospective_session = RetrospectiveSession.find(params[:session_id])
    stream_for retrospective_session
    Rails.logger.info "ActionCable: Successfully subscribed to session #{retrospective_session.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    Rails.logger.info "ActionCable: Unsubscribed from session"
  end
end
