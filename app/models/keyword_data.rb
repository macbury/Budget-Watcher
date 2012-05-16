class KeywordData < ActiveRecord::Base
  belongs_to :category
  attr_accessible :category_id, :sum, :word
  validates :word, presence: true
end
