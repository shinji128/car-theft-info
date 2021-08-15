class Post < ApplicationRecord
  belongs_to :user
  had_many :images, dependent: :destroy
end
