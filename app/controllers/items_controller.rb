class ItemsController < ApplicationController

rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  # This route should show all items for one individual user
  # GET /users/:user_id/items
  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
    else
    items = Item.all
    end
    render json: items, include: :user
  end

  # This route should show one item matching the :id from the URL
  # GET /users/:user_id/items/:id
  def show
    item = Item.find(params[:id])
    render json: item
  end

  # This route should create a new item that belongs to a user
  # POST /users/:user_id/items
  def create
      user = User.find(params[:user_id])
      item = user.items.create(item_params)
    render json: item, status: :created
  end


  private

  def item_params
    params.permit(:name, :description, :price)
  end

  def render_not_found_response(exception)
    render json: { error: "#{exception.model} not found" }, status: :not_found
  end
end
