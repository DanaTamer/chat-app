class ChatsController < ApplicationController
  before_action :set_application, only: [:index, :show, :destroy]
  before_action :set_chat, only: [:show, :destroy]

  # GET /applications/:application_token/chats
  def index
    @chats = @application.chats
    render json: @chats, :except=> [:id, :application_id]
  end

  # GET /applications/:application_token/chats/:number
  def show
    render json: @chat, :except=> [:id, :application_id]
  end

 # POST /applications/:application_token/chats
  def create
    chat_number = get_next_number
    $redis.set("#{params[:application_token]}_#{chat_number}_next_message_number", 1)
    CreateChatJob.perform_async(params[:application_token], chat_number)
    render json: { message: 'Chat created' }, status: :created
  end

  # DELETE /applications/:application_token/chats/:number
  def destroy
    @chat.with_lock do
      @chat.destroy!
    end
    @application.with_lock do
      @application.decrement!(:chats_count)
    end
    render "chat deleted successfully", status: :ok
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_application
    @application = Application.find_by(token: params[:application_token])
    render json: { error: 'Application not found' }, status: :not_found unless @application
  end

  def set_chat
    @chat = @application.chats.find_by(number: params[:number])
    render json: { error: 'Chat not found' }, status: :not_found unless @chat
  end

  # Only allow a trusted parameter "white list" through.
  def chat_params
    params.require(:chat).permit(:number)
  end

  def get_next_number
    key = "#{params[:application_token]}_next_chat_number"
    output = $redis.get(key).to_i
    loop do
      new_value = output + 1
      break if $redis.compare_and_swap(key, output, new_value)
      output = $redis.get(key).to_i
    end
    return output
  end
  
end
