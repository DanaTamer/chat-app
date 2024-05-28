class CreateChatJob
  include Sidekiq::Worker

  def perform(token, number)
    params = token
    @application = Application.find_by("token": token)
    @chat = @application.chats.new(number: number)  
    @application.with_lock do
      @application.increment!(:chats_count)
      @application.save!
    end
  end
end
  