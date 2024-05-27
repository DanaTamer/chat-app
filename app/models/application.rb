class Application < ApplicationRecord
    has_many :chats, dependent: :destroy
    validates :name, presence: true
    has_secure_token #added
  end