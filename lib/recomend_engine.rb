
# jedzenie

# dzisiaj byłem w burgerkingu

# dzisiaj -> czas(17), programowanie(12)
# byłem -> wczasy(13), wyjazd(12)
# burgerkingu -> jedzenie(32), posiłek(11)

module RecomendEngine
  MinWordLength  = 3

  def analyze_category
    return if !(self.category_id.present? && (self.category_id_was.nil? || self.category_id_changed?))
    Rails.logger.info "There is change in category, keywords are: #{words.inspect}"
    words.each do |word|
      self.category.incr_word!(word)
    end
  end

  def words
    @words ||= self.description.split(/\b/i).map(&:strip).reject { |word| word.length < RecomendEngine::MinWordLength }
  end

  def build_connections
    keywords = KeywordData.where(name: @words).group(:category_id).sum(:word_count)

  end

end