class MessagesController < ApplicationController
  before_action :set_application, :set_chat, only: [:show, :index, :destroy, :search]
  before_action :set_message, only: [:show, :update, :destroy]

  # GET /applications/:application_token/chats/:chat_number/messages
  def index
    @messages = @chat.messages
    render json: @messages, :except=> [:id, :chat_id], status: :ok
  end

  # GET /applications/:application_token/chats/:chat_number/messages/:message_number
  def show
    render json: @message, status: :ok, :except=> [:id, :chat_id], status: :ok
  end


  # POST /applications/:application_token/chats/:chat_number/messages
  def create
    message_number = get_next_number
    msg = [
      params[:application_token],
      params[:chat_number],
      message_number,
      params[:message]
    ]
    CreateMessageJob.perform_async(msg)
    render json: { message: 'Message created check' }, :except=> [:id, :chat_id], status: :created
  end

  # PATCH/PUT /applications/:application_token/chats/:chat_number/messages/:message_number
  def update
    msg = [
      params[:application_token],
      params[:chat_number],
      message_number,
      params[:message]
    ]
    UpdateMessageJob.perform_async(msg)
    render json: { message: 'Message updated' }, status: :accepted
  end

  # DELETE /applications/:application_token/chats/:chat_number/messages/:message_number
  def destroy
    @message.with_lock do
      @message.destroy!
    end
    @chat.with_lock do
      @chat.decrement!(:message_count)
    end
    render "message deleted successfully", status: :ok
  end

  
  def search
    @result = Message.search(params[:message])
    render json: @result, :except=> [:id, :chat_id], status: :ok
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_application
    @application = Application.find_by(token: params[:application_token])
    render json: { error: 'Application not found' }, status: :not_found unless @application
  end

  def set_chat
    @chat = @application.chats.find_by(number: params[:number]) if @application
    render json: { error: 'Chat not found' }, status: :not_found unless @chat
  end
    
  def set_message
    @message = @chat.messages.find_by(number: params[:message_number]) if @chat
    render json: { error: 'Message not found' }, status: :not_found unless @message
  end
  
  # Only allow a trusted parameter "white list" through.
  def message_params
    params.require(:message).permit(:body)
  end

  def get_next_number
    key = "#{params[:application_token]}_next_message_number"
    output = $redis.get(key).to_i
    loop do
      new_value = output + 1
      break if $redis.compare_and_swap(key, output, new_value)
      output = $redis.get(key).to_i
    end
    return output
  end

end
