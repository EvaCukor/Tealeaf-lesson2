class Card

  attr_accessor :suit, :value

  def initialize(s, v)
    @suit = s
    @value = v
  end

end

class Deck

  attr_accessor :deck

  SUITS = ['Hearts', 'Diamonds', 'Spades', 'Clubs']
  CARDS = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace']

  def initialize
    @deck = []
    SUITS.each do |suit|
      CARDS.each do |value|
        @deck << Card.new(suit, value)
      end
    end
    scramble!
  end

  def scramble!        
    deck.shuffle!
  end

  def deal      
    deck.pop
  end

end

class Hand

  attr_accessor :owner, :hand

  BLACKJACK = 21

  def initialize(owner)
    @owner = owner
    @hand = []
  end

  def add_card(card)
    hand.push(card)
  end 

  def sum
    values = hand.map{|card| card.value}
    total = 0
    values.each do |value|
      if value == "Ace"
        total += 11
      elsif value.to_i == 0
        total += 10
      else
        total += value.to_i
      end
    end

    values.select{|value| value == "Ace"}.count.times do
      total -= 10 if total > 21
    end

    total
  end

  def show_hand
    puts "\n#{owner}'s cards are:\n" 
    hand.each do |card|
      puts card.suit + "-" + card.value
    end 
    puts "Their total value is: " + sum.to_s
  end

  def blackjack_win_bust
    if self.sum == BLACKJACK
      puts "\n#{owner} has hit blackjack!"
      exit
    elsif self.sum > BLACKJACK
      puts "\n#{owner} has lost."
      exit
    end
  end

  def deal_sequence(deck)
    self.add_card(deck.deal)
    self.show_hand
    sleep(1)
    self.blackjack_win_bust
  end

end

class Game

  attr_accessor :player_hand, :dealer_hand, :deck

  BLACKJACK = 21
  DEALER_HIT_MIN = 17
  CHOICES = ["H", "S"]

  def initialize(player_name)
    @player_hand = Hand.new(player_name)
    @dealer_hand = Hand.new("Dealer")
    @deck = Deck.new
  end

  def initial_deal
    sleep(1)

    for i in 1..2 do
      player_hand.add_card(deck.deal)
      dealer_hand.add_card(deck.deal)
    end

    player_hand.show_hand
    dealer_hand.show_hand

    player_hand.blackjack_win_bust
  end

  def compare_hands
    puts "\nThe total value of #{player_hand.owner}'s cards is #{player_hand.sum} and the total value of #{dealer_hand.owner}'s cards is #{dealer_hand.sum}."
    if player_hand.sum > dealer_hand.sum
      puts "\n#{player_hand.owner} has won!"
    elsif player_hand.sum < dealer_hand.sum
      puts "\n#{dealer_hand.owner} has won!"
    end      
  end

  def player_turn
    while player_hand.sum < BLACKJACK
      puts "\nWould you like to hit (H) or stay (S)?"
      hit_or_stay = gets.chomp.upcase

      if !CHOICES.include?(hit_or_stay)
        puts "\nYou must enter either H or S:"
        next
      end

      if hit_or_stay == "S"
        puts "\nYou have chosen to stay.\n\n"
        sleep(1)
        break
      elsif hit_or_stay == "H"
        puts "\nYou will be dealt a new card.\n\n"
        sleep(1)
      end

      player_hand.deal_sequence(@deck)
    end
  end

  def dealer_turn
    dealer_hand.blackjack_win_bust

    puts "\n#{dealer_hand.owner} will deal to herself now.\n\n"

    sleep(1)

    while dealer_hand.sum < DEALER_HIT_MIN
      dealer_hand.deal_sequence(@deck)
      sleep(1)
    end

    while dealer_hand.sum >= DEALER_HIT_MIN && dealer_hand.sum < BLACKJACK do
      dealer_choice = CHOICES.sample
      if dealer_choice == "H"
        puts "\n#{dealer_hand.owner} has decided to hit.\n\n"
        sleep(1)
        dealer_hand.deal_sequence(@deck)
        sleep(1)
      elsif dealer_choice == "S"
        puts "\n#{dealer_hand.owner} has decided to stay."
        sleep(1)
        break
      end
    end
  end

  def play
    initial_deal
    player_turn
    dealer_turn
    compare_hands
  end

end

puts "\nWelcome to the Blackjack game! What is your name?"
player_name = gets.chomp.capitalize
blackjack = Game.new(player_name)
puts "\nHi, #{player_name}! The dealer will start the game now.\n\n\n"
blackjack.play