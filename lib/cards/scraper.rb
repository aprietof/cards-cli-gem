class Cards::Scraper

  def initialize(url = "http://www.comparecards.com/best-credit-card-offers")
    @url = url
  end

  # Scrapes a credit card website and return an array of CreditCards
  def get_cards
    @doc = Nokogiri::HTML(open(@url))
    card_links = @doc.css("div.snap-feat")
    id = 0

    card_links.collect do |card|
      id += 1
      c = Cards::CreditCard.new(card.css("h3 a.detail-tog").text)
      c.id = id
      c.offer = card.css("div.wrap div.col p").first.text
      c.fees = card.css(".hide .col p").first.text
      c.credit_needed = card.css("a.card-snapshot-credit-tip").text.strip
      c.href = card.css(".bot-links a.lrn-more").attr("href").value
      c.apply_link = card.css("div.last div.wrap a").attr("href").value
      c
    end
  end

  # Returns an updated title of the website
  def get_title
    title = @doc.css("div.headline h1").text.gsub(" From Our Partners", "")
  end

  # Scrapes an individual CreditCard website and prints a document
  def get_info(card_id)
    href = ""
    Cards::CreditCard.all.find {|card| href = card.href if card.id == card_id}

    card_page = Nokogiri::HTML(open(href))
    puts "\n#{card_page.css(".head-contain h1").text.strip}" # Card Title
    puts "\n#{card_page.css("ul li.overall").text.strip}" # Rating
    puts "\n#{card_page.css(".sec .title")[1].text}" # Title "The Good"
    puts "\n#{card_page.css(".content .review")[1].text.strip}" # The Good
    puts "\n#{card_page.css(".sec .title")[2].text}" # Tilte "The Not So Good"
    puts "\n#{card_page.css(".content .review")[2].text.strip}" # The Not So Good
    puts "\n#{card_page.css(".sec .title")[0].text}" # Title "Bottom Line"
    puts "\n#{card_page.css(".content .review")[0].text.strip}" # Bottom Line
    puts ""
  end


end