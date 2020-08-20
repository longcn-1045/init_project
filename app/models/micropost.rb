class Micropost < ApplicationRecord
  belongs_to :user

  has_one_attached :image

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.micropost.content_max_lenght}
  validates :image,
    content_type: {in: Settings.micropost.image_type_in.split,
                   message: I18n.t("microposts.image_type_message")},
    size: {less_than: Settings.micropost.image_size.megabytes,
           message: I18n.t("microposts.image_type_message")}

  scope :recent_posts, ->{order created_at: :desc}
  scope :feed, -> user_ids {where user_id: user_ids}

  def display_image
    image.variant resize_to_limit: [Settings.micropost.img_limit, Settings.micropost.img_limit]
  end
end
