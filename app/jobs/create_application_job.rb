class CreateApplicationJob
  include Sidekiq::Worker

  def perform(token, name)
    @application = Application.new(token: token, name: name)
    @application.save
    $redis.set("#{token}_next_chat_number", 1)
  end
end