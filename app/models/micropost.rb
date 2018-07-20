class Micropost < ApplicationRecord
  belongs_to :user
  mount_uploader :picture, PictureUploader
  validates :content, presence: true,
    length: {maximum: Settings.model.microposts.maximum}
  validate :picture_size
  scope :by_date, -> {order created_at: :desc}

  private

  def picture_size
    if picture.size > Settings.model.microposts.byte.megabytes
      errors.add :picture, I18n.t(".picture_too_large_size",
        size: Settings.picture.size)
    end
  end
end
