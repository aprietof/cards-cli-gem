class Cards::CLI

  def initialize
    @cards_site = Cards::Scraper.new
    @cards = @cards_site.get_cards
  end

  def call
    title
    featured
    table
    puts ""
    answer = ""
    until answer == "n" do
      puts "Would you like to learn more about a particular card? #{"(y/n)".bold}"
      puts "type #{"list".bold} if you wish to see the list again"
      answer = gets.strip.downcase
      if answer == "y"
        input = ""
        until (1..10).include? input do
          puts "Please enter and ID number between 1 and 10"
          input = gets.strip.to_i
        end
        info(input)
      elsif answer == "n"
        puts "\n- Come Back Soon -"
        puts "source: www.comparecards.com".light_black
        puts "- Goodbye -"
        puts ""
      elsif answer == "list"
        puts ""
        list
        puts ""
      end
    end         
  end


  ################## CLI METHODS ##################

  # Returns the title of the website
  def title
    puts "\n ***** #{@cards_site.get_title} ***** ".blue.bold
  end

  # Returns the featured Credit Card of the month
  def featured
    puts "\n >> Featured ★ #{@cards.first.id}. #{@cards.first.name} ★".bold
    puts ""
  end

  # Prints a table with the 10 best Credit Cards of the month starting at the second one
  def table
    tp @cards[1..9], :id, :name, {:fees => {:width => 5}}, {:offer => {:width => 17}}, :credit_needed
  end

  # Prints a list with **ONLY** the 10 best Credit Cards of the month
  def list
    title
    puts ""
    @cards[0..9].each.with_index(1) {|card, i| puts "#{i}. #{card.name}"}
  end

  # Open a website to apply for a credit card given an CreditCard id number
  def apply(card_id)
    href = ""
    @cards.find {|card| href = card.apply_link if card.id == card_id}
    system("open #{href}")
  end

  # Prints a document with information about a particular card
  def info(card_id)
    @cards_site.get_info(card_id)
    input = ""
    until ["y", "n"].include? input do
      puts "Would you like to apply for this card? (y/n)"
      input = gets.strip.downcase
      apply(card_id) if input == "y"
    end
  end

end