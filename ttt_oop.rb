# TICK TAC TOE  OOP

class Grid

  WINNING_LINES = [[1,2,3], [4,5,6], [7,8,9], [1,4,7], [2,5,8], [3,6,9], [1,5,9], [3,5,7]]

  def initialize
    @grid = {}
    (1..9).each {|position| @grid[position] = " "}
  end

  def draw
    puts "     |     |     "
    puts "  #{@grid[1]}  |  #{@grid[2]}  |  #{@grid[3]}  "
    puts "     |     |     "
    puts "-----+-----+-----"
    puts "     |     |     "
    puts "  #{@grid[4]}  |  #{@grid[5]}  |  #{@grid[6]}  "
    puts "     |     |     "
    puts "-----+-----+-----"
    puts "     |     |     "
    puts "  #{@grid[7]}  |  #{@grid[8]}  |  #{@grid[9]}  "
    puts "     |     |     "
  end

  def empty_positions
    @grid.keys.select { |position| @grid[position] == " "}
  end

  def mark(position, marker)
    @grid[position] = marker
  end

  def check_winner
    WINNING_LINES.each do |line|
      return true if (@grid.values_at(*line).count("X") == 3) || (@grid.values_at(*line).count("O") == 3)
    end
    false
  end

end

class Player

  attr_accessor :name, :marker

  def initialize(name, marker)
    @name = name
    @marker = marker
  end

end

class Game

  def player_chooses_position
    if @current_player == @human
      begin
        puts "Pick a position by entering a number between 1 and 9:"
        player_choice = gets.chomp.to_i
      end until @board.empty_positions.include?(player_choice)
    elsif @current_player == @computer
      player_choice = @board.empty_positions.sample
    end
    @board.mark(player_choice, @current_player.marker)
  end

  def alternate_player
    if @current_player == @human
      @current_player = @computer
    elsif @current_player == @computer
      @current_player = @human
    end
  end

  def play
    @board = Grid.new
    @human = Player.new("Eve", "X")
    @computer = Player.new("Wall-E", "O")
    @current_player = @human
    @board.draw
    loop do 
      player_chooses_position
      @board.draw
      if @board.check_winner
        puts "The winner is #{@current_player.name}!"
        break
      elsif @board.empty_positions == []
        puts "It's a tie!"
        break
      else
        alternate_player
      end
    end
  end

end

ttt = Game.new.play