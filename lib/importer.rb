require "dummy_transaction"

class Importer

  def initialize(file, type)
    @file_name = file
    @type = type
    
  end

  def parse(&block)
    send("parse_#{@type.to_s}", &block)
  end

  # 0. Data księgowania
  # 1. Data waluty
  # 2. Szczegóły odbiorcy/nadawcy
  # 3. Rachunek odbiorcy/nadawcy
  # 4. Tytułem
  # 5. Kwota operacji
  # 6. Waluta
  # 7. Numer referencyjny
  # 8. Typ operacji\r
  def parse_pekao24
    content = File.open(@file_name, "r:Windows-1250").read
    lines = content.split("\n")[1..-1].map { |l| l.split("\t") }
    lines.each do |line|
      transaction            = DummyTransaction.new
      transaction.amount     = Money.parse(line[5], line[6])
      transaction.currency   = line[6]
      transaction.name       = line[4].empty? ? line[2] : line[4]
      transaction.publish_at = Date.parse(line[0])
      yield transaction
    end
  end

end