class CreateApplicationJob
    include Sidekiq::Worker
  
    def perform(token, name)
      @application = App.new(token: token, name: name)
      @application.save
      $redis.set("#{token}_next_chat_number", 1)
    end+
  end