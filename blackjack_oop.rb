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

  attr_accessor :name, :hand

  def initialize(name)
    @name = name
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
    puts "\n#{name}'s cards are:\n" 
    hand.each do |card|
      puts card.suit + "-" + card.value
    end 
    puts "Their total value is: " + sum.to_s
  end

end

class Game

  BLACKJACK = 21
  DEALER_HIT_MIN = 17
  CHOICES = ["H", "S"]

  def blackjack_win_bust(name, total)
    if total == BLACKJACK
      puts "\n#{name} has hit blackjack!"
      exit
    elsif total > BLACKJACK
      puts "\n#{name} has lost."
      exit
    end
  end

  def initial_deal(player_hand, dealer_hand, deck)
    sleep(1)

    for i in 1..2 do
      player_hand.add_card(deck.deal)
      dealer_hand.add_card(deck.deal)
    end

    player_hand.show_hand
    dealer_hand.show_hand

    blackjack_win_bust(player_hand.name, player_hand.sum)
  end

  def deal_sequence(hand, deck)
    hand.add_card(deck.deal)
    hand.show_hand
    sleep(1)
    blackjack_win_bust(hand.name, hand.sum)
  end

  def compare_hands(hand1, hand2)
    puts "\nThe total value of #{hand1.name}'s cards is #{hand1.sum} and the total value of #{hand2.name}'s cards is #{hand2.sum}."
    if hand1.sum > hand2.sum
      puts "\n#{hand1.name} has won!"
    elsif hand1.sum < hand2.sum
      puts "\n#{hand2.name} has won!"
    end      
  end

  def player_turn(hand, deck)
    while hand.sum < BLACKJACK
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

      deal_sequence(hand, deck)
    end
  end

  def dealer_turn(hand, deck)
    blackjack_win_bust(hand.name, hand.sum)

    puts "\n#{hand.name} will deal to herself now.\n\n"

    sleep(1)

    while hand.sum < DEALER_HIT_MIN
      deal_sequence(hand, deck)
      sleep(1)
    end

    while hand.sum >= DEALER_HIT_MIN && hand.sum < BLACKJACK do
      dealer_choice = CHOICES.sample
      if dealer_choice == "H"
        puts "\n#{hand.name} has decided to hit.\n\n"
        sleep(1)
        deal_sequence(hand, deck)
        sleep(1)
      elsif dealer_choice == "S"
        puts "\n#{hand.name} has decided to stay."
        sleep(1)
        break
      end
    end
  end

  def play
    puts "\nWelcome to the Blackjack game! What is your name?"
    player_name = gets.chomp.capitalize
    deck = Deck.new
    dealer_hand = Hand.new("Dealer")
    player_hand = Hand.new(player_name)
    puts "\nHi, #{player_name}! The dealer will start the game now.\n\n\n"

    initial_deal(player_hand, dealer_hand, deck)

    player_turn(player_hand, deck)

    dealer_turn(dealer_hand, deck)

    compare_hands(dealer_hand, player_hand)
  end

end

blackjack = Game.new.play