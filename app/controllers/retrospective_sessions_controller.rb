class RetrospectiveSessionsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  def show
    @retrospective_session = RetrospectiveSession.find(params[:id])
  end

  def show_by_uuid
    @retrospective_session = RetrospectiveSession.find_by!(uuid: params[:uuid])
    render :show
  end

  def create
    @retrospective_session = RetrospectiveSession.create!
    redirect_to retrospective_session_path(@retrospective_session)
  end

  private

  def render_not_found
    render 'errors/not_found', status: :not_found
  end
end
