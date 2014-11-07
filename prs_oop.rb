# PAPER ROCK SCISSORS OOP

class Player
  attr_reader :name
  attr_accessor :choice 

  def initialize(n)
    @name = n
  end
end

class Human < Player
  def choose
    self.choice = ""
    while !Game::CHOICES.keys.include?(self.choice) do
      puts "Please enter 'P', 'R' or 'S' to choose between paper, rock and scissors."
      self.choice = gets.chomp.upcase
    end 
  end
end

class Computer < Player
  def choose
    self.choice = Game::CHOICES.keys.sample
  end
end

class Game
  CHOICES = {"P" => "Paper", "R" => "Rock", "S" => "Scissors"}

  attr_reader :human, :computer 

  def initialize
    @human = Human.new("Bob")
    @computer = Computer.new("The Computer")
  end

  def notify
    puts "You picked #{Game::CHOICES[human.choice]} and the computer picked #{Game::CHOICES[computer.choice]}."
  end

  def compare_choices
    if human.choice == computer.choice
      puts "It's a tie."
    elsif (human.choice == "P" && computer.choice == "R") || (human.choice == "R" && computer.choice == "S") || (human.choice == "S" && computer.choice == "P")
      puts "You won!"
    elsif (human.choice == "P" && computer.choice == "S") || (human.choice == "R" && computer.choice == "P") || (human.choice == "S" && computer.choice == "R")
      puts "The computer won!"
    end

  end

  def play
    human.choose
    computer.choose
    notify
    compare_choices
  end
end

prs = Game.new.play