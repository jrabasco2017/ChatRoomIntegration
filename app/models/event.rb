class Event < ApplicationRecord
  has_many :parties
  has_many :users, through: :parties
  belongs_to :user

  validates :name, presence: true, length: { maximum: 50 }
  has_attached_file :avatar,
  :path => ":rails_root/public/images/:attachment/:id/:basename_:style.:extension",
  :url => "/images/:attachment/:id/:basename_:style.:extension",
  :styles => {
    :thumb    => ['200x200#',  :jpg, :quality => 70],
    :preview  => ['480x480#',  :jpg, :quality => 70],
    :large    => ['600>',      :jpg, :quality => 70],
    :retina   => ['1200>',     :jpg, :quality => 30]
  },
  :convert_options => {
    :thumb    => '-set colorspace sRGB -strip',
    :preview  => '-set colorspace sRGB -strip',
    :large    => '-set colorspace sRGB -strip',
    :retina   => '-set colorspace sRGB -strip -sharpen 0x0.5'
  }

  validates_attachment :avatar,
    :presence => true,
    :size => { :in => 0..10.megabytes },
    :content_type => { :content_type => /^image\/(jpeg|png|gif|tiff)$/ }


end
