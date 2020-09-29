# frozen_string_literal: true

# defines how to play
class Game
  @board = 0
  @player2 = 0
  @first_turn = 0
  def initialize
    @board = GameState.new
  end

  def new_game
    puts 'Welcome to Tic-Tac-Toe!'
    puts 'Would you like to play with another player, or against the computer?'
    puts 'Please enter 1 for player, 2 for computer:'
    # 2 player or 1 vs AI
    @player2 = gets.to_i
    until [1, 2].include?(@player2)
      puts "That's not what I asked for."
      puts 'Please enter 1 for player, 2 for computer:'
      @player2 = gets.to_i
    end
    # if AI decide who plays first
    if @player2 == 2
      puts 'Who will play X and go first?'
      puts 'Please enter 1 for yourself, 2 for the computer, or 3 to flip a coin.'
      @first_turn = gets.to_i
      until (1..3).include?(@first_turn)
        puts "That's not what I asked for."
        puts 'Please enter 1 for yourself, 2 for the computer, or 3 to flip a coin.'
        @first_turn = gets.to_i
      end
    else
      @first_turn = 1
    end
    if @first_turn == 3
      coin = Random.new
      winner = ['you', 'the computer']
      @first_turn = coin.rand(2) + 1
      puts "Looks like #{winner[@first_turn - 1]} won the coin toss #{winner[@first_turn - 1]} will go first."
    end
    shape = 1
    game_loop(shape)
  end

  def win_check
    case @board.winner
    when -1
      puts 'O has won the game!'
    when 0
      puts 'The game was a draw'
    when 1
      puts 'X has won the game!'
    else
      return
    end
    puts 'Would you like to play again?'
    puts 'Type 1 for yes, 2 to quit.'
    response = gets
    return Game.new.new_game if response.to_i == 1

    exit
  end

  def change_turn(shape)
    return 0 if shape == 1
    return 1 if shape.zero?
  end

  def game_loop(shape)
    shape = change_turn(shape)
    @board.display_board
    win_check
    # if 2 players each take turns
    if @player2 == 1
      player_play(shape)
    # else AI takes turns
    else
      if @first_turn == 1
        player_play(shape)
      else
        computer_play(shape)
      end
    end
  end

  def player_play(shape)
    convert = %w[X O]
    puts "Please enter a position to place an #{convert[shape]}"
    move = gets
    unless (1..9).include?(move.to_i)
      puts "That's not what I asked for."
      puts "Please enter a position to place an #{convert[shape]}"
      move = gets
    end
    begin
      @board.position_check(move)
    rescue StandardError
      puts 'Someone has already moved there! Try again:'
      move = gets
      retry
    end
    @board.make_move(move, convert[shape])
    game_loop(shape)
  end

  def computer_play(shape)
    convert = %w[X O]
    cur_board = @board.position
    @board.make_move(minimax(cur_board, _, true), convert[shape])
  end
end

# defines the board
class GameState
  attr_reader :position
  @position = []
  @winning_positions = []
  def initialize
    @position = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    # array of winning positions sorted by row, column, diagonal respectively
    @winning_positions = [0, 0, 0, 0, 0, 0, 0, 0]
  end

  def position_check(position)
    raise unless @position[position.to_i - 1].is_a? Numeric
  end

  def display_board
    (0..2).each do |i|
      puts '-------------'
      puts "| #{@position[3 * i]} | #{@position[3 * i + 1]} | #{@position[3 * i + 2]} |"
    end
    puts '-------------'
  end

  def make_move(position, player)
    @position[position.to_i - 1] = player
    score_keeper(position, player)
  end

  def score_keeper(position, player, board=@winning_positions)
    index = []
    case position.to_i
    when 1
      index = [0, 3, 6]
    when 2
      index = [0, 4]
    when 3
      index = [0, 5, 7]
    when 4
      index = [1, 3]
    when 5
      index = [1, 4, 6, 7]
    when 6
      index = [1, 5]
    when 7
      index = [2, 3, 7]
    when 8
      index = [2, 4]
    when 9
      index = [2, 5, 6]
    end
    if player == 'X'
      index.each do |i|
        board[i] += 1
      end
    else
      index.each do |i|
        board[i] -= 1
      end
    end
  end

  def winner(win_condition = @winning_positions)
    win_condition.each do |result|
      return 1 if result.to_i == 3
      return -1 if result.to_i == -3
    end
    count = 0
    @position.each do |draw|
      count += 1 unless draw.is_a? Numeric
    end
    return 0 if count == 9
  end

  def minimax(board, win_condition = @winning_positions, computer = true)
    score = winner(win_condition)
    return 1 if score == 1
    return -1 if score == -1
    return 0 unless board.each(&:zero?)

    (0..8).each do |i|
      next unless board[i].zero?

      new_board = win_condition
      if computer
        best = -2
        best = max(best, minimax(board, new_board, !computer))
      else
        best = 2
        best = min(best, minimax(board, new_board, !computer))
      end
    end
  end
end

Game.new.new_game
