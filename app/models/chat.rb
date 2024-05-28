class Chat < ApplicationRecord
  belongs_to :application, counter_cache: true #check counter cache func
  has_many :messages, dependent: :destroy
end
