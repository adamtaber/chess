require_relative '../lib/chess'
require_relative '../lib/pieces'

class PlayGame
  attr_accessor :turn
  attr_accessor :game_board
  attr_reader :chess_piece

  LETTERS = {"a": 0, "b": 1, "c": 2, "d": 3, "e": 4, "f": 5, "g": 6, "h": 7}
  BLACK = {rook: "\u265c", knight: "\u265e", bishop: "\u265d", queen: "\u265b", king: "\u265a", pawn: "\u265f"}
  WHITE = {rook: "\u2656", knight: "\u2658", bishop: "\u2657", queen: "\u2655", king: "\u2654", pawn: "\u2659"}

  def initialize
    @game_board = ChessBoard.new
    @chess_piece = ChessPiece.new
    @turn = 0
    @piece_position = nil
    @end_position = nil
    @move = nil
  end

  def game_sequence
    game_board.print_board
    get_player_input
    input_valid?
  end

  def get_player_input
    board = game_board.board
    if @turn % 2 == 0
      puts "White, please enter the position of the piece you would like to move, followed by the desired placement"
    elsif @turn % 2 == 1
      puts "Black, please enter the position of the piece you would like to move, followed by the desired placement"
    end
    input = gets.chomp.split
    check_input_format(input)
    item_num = LETTERS[:"#{input[0][0]}"]
    row_num = (8 - input[0][1].to_i)
    new_item_num = LETTERS[:"#{input[1][0]}"]
    new_row_num = (8 - input[1][1].to_i)
    check_new_items(new_row_num, new_item_num)
    @piece_position = [[row_num], [item_num]]
    @end_position = [[new_row_num], [new_item_num]]
    calculate_move(row_num, new_row_num, item_num, new_item_num)
  end

  def check_input_format(input)
    if input.length != 2
      get_player_input
    elsif input[0].length != 2 || input[1].length != 2
      get_player_input
    elsif LETTERS.has_key?(:"#{input[0][0]}") != true || LETTERS.has_key?(:"#{input[1][0]}") != true
      get_player_input
    elsif input[0][1].to_i > 8 || input[0][1].to_i < 1 || input[1][1].to_i > 8 || input[1][1].to_i < 1
      get_player_input
    end
  end

  def check_new_items(new_row, new_item)
    if new_row > 7 || new_row < 0
      puts "Invalid input"
      get_player_input
    elsif new_item > 7 || new_item < 0
      puts "Invalid input"
      get_player_input
    end
  end

  def calculate_move(row_num, new_row_num, item_num, new_item_num)
    vertical_move = new_row_num - row_num
    horizontal_move = new_item_num - item_num
    @move = [vertical_move, horizontal_move]
  end

  def input_valid?
    board = game_board.board
    @piece_position = @piece_position.flatten
    @end_position = @end_position.flatten
    start_place = board[@piece_position[0]][@piece_position[1]]
    end_place = board[@end_position[0]][@end_position[1]]
    if chess_piece.correct_color?(start_place, @turn) != true
      puts "Please choose one of your own pieces"
      get_player_input
    end
    if valid_move? != true
      puts "Please choose a valid move"
      get_player_input
    end
    if end_place != " "
      if game_board.opposite_color?(end_place, @turn) != true
        puts "Please choose a move including a correct end position"
        get_player_input
      end
    end
    if in_check?(@turn) == true
      puts "Please choose a move that does not place your king in check"
      get_player_input
    end
  end

  def valid_move?
    chess_piece.create_move_list(game_board.board[@piece_position[0]][@piece_position[1]], @piece_position, game_board.board).include?(@move)
  end

  def create_temp_board
    temp_board = game_board.board
    temp_board[@end_position[0]][@end_position[1]] = temp_board[@piece_position[0]][@piece_position[1]]
    temp_board[@piece_position[0]][@piece_position[1]] = " "
    temp_board
  end

  def in_check?(turn)
    temp_board = create_temp_board
    attack_king?(temp_board, turn)
  end

  def attack_king?(temp_board, turn)
    check = false
    temp_board.each_index do |row|
      temp_board[row].each_with_index do |piece, i|
        if turn % 2 == 0
          if piece != " " && BLACK.has_value?(piece) && piece != "\u265f" && piece != "\u265a"
            if chess_piece.get_end_position_values([row, i], temp_board, piece).include?("\u2654") == true
              check = true
            end
          end
        elsif turn % 2 == 1
          if piece != " " && WHITE.has_value?(piece) && piece != "\u2659" && piece != "\u2654"
            if chess_piece.get_end_position_values([row, i], temp_board, piece).include?("\u265a") == true
              check = true
            end
          end
        end
      end
    end
    check
  end
end

test = PlayGame.new
test.get_player_input
test.input_valid?
