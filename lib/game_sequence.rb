require 'yaml'
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
    @save_game = false
    @save_board = @game_board.board
  end

  def save_game
    yaml_hash = {'save_board' => @save_board, 'turn' => @turn,
    'piece_position' => @piece_position, 'end_position' => @end_position, 'move' => @move, 
    'save_game' => @save_game}
    if Dir.exists?('save_files') == false
      Dir.mkdir('save_files')
    end
    puts "\n"
    puts "Please type a name for your save file"
    file_name = gets.chomp
    File.open("save_files/#{file_name}.yaml", "w") do |file|
      file.puts YAML.dump(yaml_hash)
    end
    puts "\n"
    puts "Your game has been saved, thank you for playing"
    @save_game = true
  end

  def load_game
    files = Dir.entries('save_files')
    files.each_index do |index|
      puts "#{index}: #{files[index]}"
    end
    puts "type the number of the save file you would like to load"
    number = gets.chomp.to_i
    File.open("save_files/#{files[number]}", 'r') do |file|
      save = YAML.load(file)
      @save_board = save["save_board"]
      @turn = save["turn"]
      @piece_position = save["piece_position"]
      @end_position = save["end_position"]
      @move = save["move"]
      @save_game = save["save_game"]
    end
    puts "Remember that you can save the game by typing 'save' instead of your a move sequence"
    @game_board.board = @save_board
    game_sequence
  end

  def game_intro
    puts "Welcome to Chess!"
    if Dir.exists?('save_files')
      puts "Would you like to load a previous game? (y/n)"
      answer = gets.chomp.downcase
      if answer == "y"
        load_game
      elsif answer == "n"
        puts "Remember that you can save the game by typing 'save' instead of move sequence"
        game_sequence
      else
        game_intro
      end
    end
    if Dir.exists?('save_files') == false
      puts "You can save the game by typing 'save' instead of a move sequence"
      game_sequence
    end
  end

  def game_sequence
    game_board.print_board
    until check_mate? || @save_game == true
      player_in_check?
      get_player_input
      if @save_game == false                   
        move_piece
        game_board.print_board
        @turn += 1
        clear_en_passant
      end
    end
    if @save_game == true
    elsif @turn % 2 == 1
      puts "Checkmate, White is the winner"
    elsif @turn % 2 == 0
      puts "Checkmate, Black is the winner"
    end
  end

  def get_player_input
    board = game_board.board
    if @turn % 2 == 0
      puts "White, please enter the position of the piece you would like to move, followed by the desired placement"
    elsif @turn % 2 == 1
      puts "Black, please enter the position of the piece you would like to move, followed by the desired placement"
    end
    input = gets.chomp.split
    if input.join == "save"
      save_game
    else
      until input_correct_range?(input) && check_items_and_move(input) && input_valid?
        if @turn % 2 == 0
          puts "White, please enter the position of the piece you would like to move, followed by the desired placement"
        elsif @turn % 2 == 1
          puts "Black, please enter the position of the piece you would like to move, followed by the desired placement"
        end
        input = gets.chomp.split
      end
    end
  end

  def input_correct_range?(input)
    if input.length != 2
      false
    elsif input[0].length != 2 || input[1].length != 2
      false
    elsif LETTERS.has_key?(:"#{input[0][0]}") != true || LETTERS.has_key?(:"#{input[1][0]}") != true
      false
    elsif input[0][1].to_i > 8 || input[0][1].to_i < 1 || input[1][1].to_i > 8 || input[1][1].to_i < 1
      false
    else
      true
    end
  end

  def check_new_items(new_row, new_item)
    if new_row > 7 || new_row < 0
      puts "Invalid input"
      false
    elsif new_item > 7 || new_item < 0
      puts "Invalid input"
      false
    else
      true
    end
  end

  def calculate_move(row_num, new_row_num, item_num, new_item_num)
    vertical_move = new_row_num - row_num
    horizontal_move = new_item_num - item_num
    @move = [vertical_move, horizontal_move]
  end

  def check_items_and_move (input)
    check_items = false
    item_num = LETTERS[:"#{input[0][0]}"]
    row_num = (8 - input[0][1].to_i)
    new_item_num = LETTERS[:"#{input[1][0]}"]
    new_row_num = (8 - input[1][1].to_i)
    if check_new_items(new_row_num, new_item_num)
      check_items = true
    end
    @piece_position = [row_num, item_num]
    @end_position = [new_row_num, new_item_num]
    calculate_move(row_num, new_row_num, item_num, new_item_num)
    check_items
  end

  def input_valid?
    board = game_board.board
    start_place = board[@piece_position[0]][@piece_position[1]]
    end_place = board[@end_position[0]][@end_position[1]]
    if chess_piece.correct_color?(start_place, @turn) != true
      puts "Please choose one of your own pieces"
      false
    elsif valid_move? != true
      puts "Please choose a valid move"
      false
    elsif in_check?(@turn) == true
      puts "Please choose a move that does not place your king in check"
      false
    else
      true
    end
  end

  def valid_move?
    chess_piece.create_move_list(game_board.board[@piece_position[0]][@piece_position[1]], @piece_position, game_board.board).include?(@move)
  end

  def create_temp_board(start_position=@piece_position, end_position=@end_position)
    temp_board = game_board.board.map do |arr|
      arr.slice(0..-1)
    end
    temp_board[end_position[0]][end_position[1]] = temp_board[start_position[0]][start_position[1]]
    temp_board[start_position[0]][start_position[1]] = " "
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
          if piece != " " && BLACK.has_value?(piece)
            if chess_piece.get_end_position_values([row, i], temp_board, piece).include?("\u2654") == true
              check = true
            end
          end
        elsif turn % 2 == 1
          if piece != " " && WHITE.has_value?(piece)
            if chess_piece.get_end_position_values([row, i], temp_board, piece).include?("\u265a") == true
              check = true
            end
          end
        end
      end
    end
    check
  end

  def move_piece
    if game_board.board[@piece_position[0]][@piece_position[1]] == "\u265f" && @move == [2, 0]
      game_board.board[@end_position[0]][@end_position[1]] = game_board.board[@piece_position[0]][@piece_position[1]]
      game_board.board[@piece_position[0]][@piece_position[1]] = " "
      game_board.board[@piece_position[0] + 1][@piece_position[1]] = "_"
      @chess_piece.black_en_passant.push([@piece_position[0] + 1,@piece_position[1]])
    elsif game_board.board[@piece_position[0]][@piece_position[1]] == "\u2659" && @move == [-2, 0]
      game_board.board[@end_position[0]][@end_position[1]] = game_board.board[@piece_position[0]][@piece_position[1]]
      game_board.board[@piece_position[0]][@piece_position[1]] = " "
      game_board.board[@piece_position[0] - 1][@piece_position[1]] = "_"
      @chess_piece.white_en_passant.push([@piece_position[0]-1, @piece_position[1]])
    elsif (game_board.board[@piece_position[0]][@piece_position[1]] == "\u265f" || game_board.board[@piece_position[0]][@piece_position[1]] == "\u2659") && game_board.board[@end_position[0]][@end_position[1]] == "_"
      game_board.board[@end_position[0]][@end_position[1]] = game_board.board[@piece_position[0]][@piece_position[1]]
      game_board.board[@piece_position[0]][@piece_position[1]] = " "
      game_board.board[@piece_position[0]][@end_position[1]] = " "
    else
      game_board.board[@end_position[0]][@end_position[1]] = game_board.board[@piece_position[0]][@piece_position[1]]
      game_board.board[@piece_position[0]][@piece_position[1]] = " "
    end
  end

  def clear_en_passant
    if @turn % 2 == 0
      @chess_piece.white_en_passant = []
    elsif @turn % 2 == 1
      @chess_piece.black_en_passant = []
    end
  end

  def check_mate?
    check_mate = true
    game_board.board.each_index do |row|
      game_board.board[row].each_with_index do |piece, i|
        if turn % 2 == 0
          if piece != " " && WHITE.has_value?(piece)
            possible_moves = chess_piece.create_move_list(piece, [row, i], game_board.board)
            possible_moves.each do |move|
              if row + move[0] > 0 && row + move[0] < 8 && i + move[1] > 0 && i + move[1] < 8
                start_position = [row, i]
                end_position = [(row + move[0]), (i + move[1])]
                temp_board = create_temp_board(start_position, end_position)
                if attack_king?(temp_board, @turn) == false
                  check_mate = false
                end
              end
            end
          end
        elsif turn % 2 == 1
          if piece != " " && BLACK.has_value?(piece)
            possible_moves = chess_piece.create_move_list(piece, [row, i], game_board.board)
            possible_moves.each do |move|
              if row + move[0] > 0 && row + move[0] < 8 && i + move[1] > 0 && i + move[1] < 8
                start_position = [row, i]
                end_position = [(row + move[0]), (i + move[1])]
                temp_board = create_temp_board(start_position, end_position)
                if attack_king?(temp_board, @turn) == false
                  check_mate = false
                end
              end
            end
          end
        end
      end
    end
    check_mate
  end

  def player_in_check?
    if attack_king?(game_board.board, @turn) == true
      if @turn % 2 == 0
        puts "White, you are now in check"
      elsif @turn % 2 == 1
        puts "Black, you are now in check"
      end
    end
  end
end

test = PlayGame.new
test.game_intro

