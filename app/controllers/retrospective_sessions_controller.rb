class RetrospectiveSessionsController < ApplicationController
  def show
    @retrospective_session = RetrospectiveSession.find(params[:id])
  end

  def create
    @retrospective_session = RetrospectiveSession.create!
    redirect_to retrospective_session_path(@retrospective_session)
  end
end
