class UpdateApplicationJob
  include Sidekiq::Worker

  def perform(token, name)
    @application = Application.find_by(token: token)
    @application.with_lock do
      @application.update(name: name)
    end
  end
end