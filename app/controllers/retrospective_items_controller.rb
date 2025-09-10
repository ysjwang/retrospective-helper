class RetrospectiveItemsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  
  def create
    @retrospective_session = RetrospectiveSession.find(params[:retrospective_session_id])
    @retrospective_item = @retrospective_session.retrospective_items.build(retrospective_item_params)
    
    if @retrospective_item.save
      render json: { 
        status: 'success', 
        message: 'Retrospective item created successfully',
        item: {
          id: @retrospective_item.id,
          category: @retrospective_item.category,
          name: @retrospective_item.name,
          comments: @retrospective_item.comments,
          due_date: @retrospective_item.due_date&.strftime("%b %d, %Y"),
          person: @retrospective_item.person
        }
      }
    else
      render json: { status: 'error', message: @retrospective_item.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  private

  def retrospective_item_params
    params.require(:retrospective_item).permit(:category, :name, :comments, :due_date, :person)
  end
end
