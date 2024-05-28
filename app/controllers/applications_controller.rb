class ApplicationsController < ApplicationController
  before_action :set_application, only: [ :show, :update, :destroy ]
  before_action :application_params, only: [:create, :update]

  # GET /applications
  def index
    @applications = Application.all
    render json: @applications, except: [:id]
  end

  # GET /applications/:token
  def show
    render json: @application, except: [:id]
  end

  # POST /applications
  def create
    token = SecureRandom.hex(10)
    CreateApplicationJob.perform_async(token, params[:name])
    render json: token, status: :created
  end

  # PATCH/PUT /applications/:token
  def update
    UpdateApplicationJob.perform_async(params[:token], params[:name])
    render json: "Application updated successfully", status: :ok
  end

  # DELETE /applications/:token
  def destroy
    if @application.destroy
      render json: "Application deleted successfully", status: :ok
    else
      render json: @application.errors, status: :unprocessable_entity
    end
  end

  private

  def application_params
    params.require(:application).permit(:name)
  end

  def set_application
    @application = Application.find_by_token!(params[:token])
  end
end