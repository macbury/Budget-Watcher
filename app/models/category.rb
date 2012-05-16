class Category < ActiveRecord::Base
  NameRegexp      = /[A-Z0-9]+/i

  has_many        :transactions, dependent: :nullify
  has_many        :keyword_datas, dependent: :delete_all
  attr_accessible :name
  validates       :name, presence: true, format: { with: Category::NameRegexp }, uniqueness: true
  has_ancestry 

  def self.uid_from_string(name)
    name.gsub(/[^A-Z0-9]+/i, "").downcase
  end

  def incr_word!(word)
    keyword_datas.find_or_initialize_by_word(word)
    keyword.sum += 1
    keyword.save
    keyword
  end
end
