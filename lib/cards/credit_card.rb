class Cards::CreditCard

  attr_accessor :name, :fees, :offer, :credit_needed, :id, :href, :apply_link

  @@all =[]

  def initialize(name)
    @name = name
    @@all << self
  end

  def self.all
    @@all
  end

end