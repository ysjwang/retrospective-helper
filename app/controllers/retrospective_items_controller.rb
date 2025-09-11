class RetrospectiveItemsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :update]
  
  def create
    @retrospective_session = RetrospectiveSession.find(params[:retrospective_session_id])
    @retrospective_item = @retrospective_session.retrospective_items.build(retrospective_item_params)
    
    if @retrospective_item.save
      # Broadcast the new item to all subscribers of this retrospective session
      begin
        Rails.logger.info "ActionCable: Broadcasting item_created for session #{@retrospective_session.id}"
        Rails.logger.info "ActionCable: Current database connection: #{ActiveRecord::Base.connection.current_database}"
        Rails.logger.info "ActionCable: Solid Cable tables exist: #{ActiveRecord::Base.connection.table_exists?('solid_cable_messages')}"
        
        RetrospectiveSessionChannel.broadcast_to(@retrospective_session, {
          type: 'item_created',
          item: {
            id: @retrospective_item.id,
            category: @retrospective_item.category, # This will be a string from the enum
            name: @retrospective_item.name,
            comments: @retrospective_item.comments,
            due_date: @retrospective_item.due_date&.strftime("%b %d, %Y"),
            person: @retrospective_item.person
          }
        })
        Rails.logger.info "ActionCable: Successfully broadcasted item_created"
      rescue => e
        Rails.logger.error "ActionCable broadcast failed: #{e.message}"
        Rails.logger.error "ActionCable broadcast error backtrace: #{e.backtrace.join("\n")}"
        # Continue with the response even if broadcast fails
      end
      
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

  def edit
    @retrospective_session = RetrospectiveSession.find(params[:retrospective_session_id])
    @retrospective_item = @retrospective_session.retrospective_items.find(params[:id])
    
    render json: {
      status: 'success',
      item: {
        id: @retrospective_item.id,
        category: @retrospective_item.category,
        name: @retrospective_item.name,
        comments: @retrospective_item.comments,
        due_date: @retrospective_item.due_date&.strftime("%Y-%m-%d"),
        person: @retrospective_item.person
      }
    }
  end

  def update
    @retrospective_session = RetrospectiveSession.find(params[:retrospective_session_id])
    @retrospective_item = @retrospective_session.retrospective_items.find(params[:id])
    
    if @retrospective_item.update(retrospective_item_params)
      # Broadcast the updated item to all subscribers of this retrospective session
      begin
        RetrospectiveSessionChannel.broadcast_to(@retrospective_session, {
          type: 'item_updated',
          item: {
            id: @retrospective_item.id,
            category: @retrospective_item.category,
            name: @retrospective_item.name,
            comments: @retrospective_item.comments,
            due_date: @retrospective_item.due_date&.strftime("%b %d, %Y"),
            person: @retrospective_item.person
          }
        })
      rescue => e
        Rails.logger.error "ActionCable broadcast failed: #{e.message}"
        # Continue with the response even if broadcast fails
      end
      
      render json: { 
        status: 'success', 
        message: 'Retrospective item updated successfully',
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

  def update_category
    @retrospective_session = RetrospectiveSession.find(params[:retrospective_session_id])
    @retrospective_item = @retrospective_session.retrospective_items.find(params[:id])
    
    if @retrospective_item.update(category: params[:category])
      # Broadcast the category change to all subscribers
      begin
        RetrospectiveSessionChannel.broadcast_to(@retrospective_session, {
          type: 'item_moved',
          item: {
            id: @retrospective_item.id,
            category: @retrospective_item.category,
            name: @retrospective_item.name,
            comments: @retrospective_item.comments,
            due_date: @retrospective_item.due_date&.strftime("%b %d, %Y"),
            person: @retrospective_item.person
          }
        })
      rescue => e
        Rails.logger.error "ActionCable broadcast failed: #{e.message}"
      end
      
      render json: { status: 'success', message: 'Item category updated successfully' }
    else
      render json: { status: 'error', message: @retrospective_item.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  private

  def retrospective_item_params
    params.require(:retrospective_item).permit(:category, :name, :comments, :due_date, :person)
  end
end
