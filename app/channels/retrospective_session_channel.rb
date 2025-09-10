class RetrospectiveSessionChannel < ApplicationCable::Channel
  def subscribed
    # Subscribe to updates for a specific retrospective session
    retrospective_session = RetrospectiveSession.find(params[:session_id])
    stream_for retrospective_session
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
