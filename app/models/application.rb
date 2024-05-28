class Application < ApplicationRecord
    has_many :chats, dependent: :destroy
    validates :name, presence: true
  end