class Message < ApplicationRecord
  belongs_to :chat
  validates :body, presence: true
  searchkick
end
