# frozen_string_literal: true

# defines how to play
class Game
  @player2 = 0
  @player_x = 0
  @board = GameState.new()
  def initialize
    puts 'Welcome to Tic-Tac-Toe!'
    puts 'Would you like to play with another player, or against the computer?'
    puts 'Please enter 1 for player, 2 for computer:'
    # 2 player or 1 vs AI
    @player2 = gets.to_i
    until [1, 2].includes?(@player2)
      puts "That's not what I asked for."
      puts 'Please enter 1 for player, 2 for computer:'
      @player2 = gets.to_i
    end
    # if AI decide who plays first
    if @player2 == 2
      puts 'Who will play X and go first?'
      puts 'Please enter 1 for yourself, 2 for the computer, or 3 to flip a coin.'
      @player_x = gets.to_i
      until [1..3].includes?(@player_x)
        puts "That's not what I asked for."
        puts 'Please enter 1 for yourself, 2 for the computer, or 3 to flip a coin.'
        @player_x = gets.to_i
      end
    else
      @player_x = 1
    end
    if @player_x == 3
      coin = Random.new
      winner = ['you', 'the computer']
      @player_x = coin.rand(2) + 1
      puts "Looks like #{winner[@player_x - 1]} won the coin toss #{winner[@player_x - 1]} will go first."
    end
    self.game_loop
  end

  def game_loop
    # if 2 players each take turns
    if player2 == 1
      self.player_play
    # else AI takes turns
    else
      if player_x == 1
        self.player_play
      else
        self.computer_play
      end
    end
  end

  def player_play
    player = ['X', 'O']
    puts "Please enter a position to place an #{player[@player_x - 1]}"
    move = gets
    unless [1..9].includes?(move)
      puts "That's not what I asked for."
      puts "Please enter a position to place an #{player[@player_x - 1]}"
    end
    board.make_move(move, @player_x)
    if @player_x == 1
      @player_x += 1
    else
      @player_x -+1
    end
    board.winner
    self.game_loop
  end

  def computer_play 
    # minimax algorithm
    if board.winner
    end
end

# defines the board
class GameState
  @position = []
  @winning_positions = [0, 0, 0, 0, 0, 0, 0, 0]
  def initialize
    @position = [1..9]
  end

  def display_board
    [1..3].each do |i|
      puts '----------------'
      puts "| #{@position[1 * i]} | #{@position[2 * i]} | #{@position[3 * i]} |"
    end
    puts '----------------'
  end

  public

  def make_move(position, player)
    if player = 1
      @position[position] = 'X'
    else
      @position[position] = 'O'
    end
    display_board
    winner
  end

  def winner
    @winning_positions.each do |result|
      if result == 3
        return 1
      elsif result == -3
        return -1
      end
    end
    @position.each do |draw|
      if draw.is_a? Numeric
        break
      else
        return 0
      end
    end
  end
end

Game.new
