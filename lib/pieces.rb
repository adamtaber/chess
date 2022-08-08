require 'yaml'
class ChessPiece
  attr_reader :color
  attr_accessor :black_en_passant
  attr_accessor :white_en_passant

  # WHITE_PIECES = { "\u2659": Pawn, "\u2656": Rook.new, "\u2657": Bishop.new, "\u2658": Knight.new, "\u2655": Queen.new, "\u2654": King.new }
  # BLACK_PIECES = { "\u265f": Pawn, "\u265c": Rook.new, "\u265d": Bishop.new, "\u265e": Knight.new, "\u265b": Queen.new, "\u265a": King.new }
  WHITE_PIECES = ["\u2659", "\u2656", "\u2657", "\u2658", "\u2655", "\u2654"]
  BLACK_PIECES = ["\u265f", "\u265c", "\u265d", "\u265e", "\u265b", "\u265a"]

  PAWN_MOVES = [[1, 0], [-1, 0]]

  ROOK_MOVES_N = [[-1, 0], [-2, 0], [-3, 0], [-4, 0], [-5, 0], [-6, 0], [-7, 0]]
  ROOK_MOVES_E = [[0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7]]
  ROOK_MOVES_W = [[0, -1], [0, -2], [0, -3], [0, -4], [0, -5], [0, -6], [0, -7]]
  ROOK_MOVES_S = [[1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0]]
  ROOK_ARRAY = [ROOK_MOVES_N, ROOK_MOVES_E, ROOK_MOVES_W, ROOK_MOVES_S]

  BISHOP_MOVES_NE = [[-1, 1], [-2, 2], [-3, 3], [-4, 4], [-5, 5], [-6, 6], [-7, 7]]
  BISHOP_MOVES_NW = [[-1, -1], [-2, -2], [-3, -3], [-4, -4], [-5, -5], [-6, -6], [-7, -7]]
  BISHOP_MOVES_SE = [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7]]
  BISHOP_MOVES_SW = [[1, -1], [2, -2], [3, -3], [4, -4], [5, -5], [6, -6], [7, -7]]
  BISHOP_ARRAY = [BISHOP_MOVES_NE, BISHOP_MOVES_NW, BISHOP_MOVES_SE, BISHOP_MOVES_SW]

  QUEEN_ARRAY = [ROOK_MOVES_N, ROOK_MOVES_E, ROOK_MOVES_W, ROOK_MOVES_S, BISHOP_MOVES_NE, BISHOP_MOVES_NW, BISHOP_MOVES_SE, BISHOP_MOVES_SW]

  KNIGHT_MOVES = [[2, 1], [2, -1], [-2, 1], [-2, -1], [1, 2], [1, -2], [-1, 2], [-1, -2]]
  
  KING_MOVES = [[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [1, -1], [-1, 1], [-1, -1]]


  def initialize
    @black_en_passant = []
    @white_en_passant = []
  end

  def correct_color?(piece_value, turn)
    if turn % 2 == 0
      WHITE_PIECES.include?(piece_value)
    elsif turn % 2 == 1
      BLACK_PIECES.include?(piece_value)
    end
  end

  def create_move_list(piece, position, board)
    moves = []
    if piece == "\u2659"
      create_white_pawn_move_list(moves, board, position)
    elsif piece == "\u265f"
      create_black_pawn_move_list(moves, board, position)
    elsif piece == "\u2654"
      create_white_king_move_list(moves, board, position)
    elsif piece == "\u265a"
      create_black_king_move_list(moves, board, position)
    elsif piece == "\u2658"
      create_white_knight_move_list(moves, board, position)
    elsif piece == "\u265e"
      create_black_knight_move_list(moves, board, position)
    elsif piece == "\u2656"
      create_white_rook_move_list(moves, board, position)
    elsif piece == "\u265c"
      create_black_rook_move_list(moves, board, position)
    elsif piece == "\u2657"
      create_white_bishop_move_list(moves, board, position)
    elsif piece =="\u265d"
      create_black_bishop_move_list(moves, board, position)
    elsif piece == "\u2655"
      create_white_queen_move_list(moves, board, position)
    elsif piece =="\u265b"
      create_black_queen_move_list(moves, board, position)
    end
  end

  def create_white_pawn_move_list(moves, board, position)
    if (position[0] - 1) > 0 && (position[0] - 1) < 8 && board[position[0] - 1][position[1]] == " "
      moves.push([-1, 0])
    end
    if position[0] == 6 && board[position[0] - 2][position[1]] == " "
      moves.push([-2, 0])
    end
    if (position[0] - 1) > 0 && (position[0] - 1) < 8 && BLACK_PIECES.include?(board[position[0] - 1][position[1] + 1])
      moves.push([-1, 1])
    end
    if (position[0] - 1) > 0 && (position[0] - 1) < 8 && @black_en_passant.include?([position[0]-1, position[1]+1])
      moves.push([-1, 1])
    end
    if (position[0] + 1) > 0 && (position[0] + 1) < 8 && BLACK_PIECES.include?(board[position[0] - 1][position[1] - 1])
      moves.push([-1, -1])
    end
    if (position[0] + 1) > 0 && (position[0] + 1) < 8 && @black_en_passant.include?([position[0]-1, position[1]-1])
      moves.push([-1, -1])
    end
    moves
  end

  def create_black_pawn_move_list(moves, board, position)
    if (position[0] + 1) > 0 && (position[0] + 1) < 8 && board[position[0] + 1][position[1]] == " "
      moves.push([1, 0])
    end
    if position[0] == 1 && board[position[0] + 2][position[1]] == " "
      moves.push([2, 0])
    end
    if (position[0] + 1) > 0 && (position[0] + 1) < 8 && WHITE_PIECES.include?(board[position[0] + 1][position[1] + 1])
      moves.push([1, 1])
    end
    if (position[0] + 1) > 0 && (position[0] + 1) < 8 && @white_en_passant.include?([position[0]+1, position[1]+1])
      moves.push([1, 1])
    end
    if (position[0] + 1) > 0 && (position[0] + 1) < 8 && WHITE_PIECES.include?(board[position[0] + 1][position[1] - 1])
      moves.push([1, -1])
    end
    if (position[0] + 1) > 0 && (position[0] + 1) < 8 && @white_en_passant.include?([position[0]+1, position[1]-1])
      moves.push([1, -1])
    end
    moves
  end

  def create_white_king_move_list(moves, board, position)
    KING_MOVES.each do |move|
      if (position[0] + move[0]) >= 0 && (position[1] + move[1]) >= 0  && (position[0] + move[0] <= 7) && (position[1] + move[1] <= 7)
        if board[position[0] + move[0]][position[1] + move[1]] == " "
          moves.push(move)
        elsif BLACK_PIECES.include?(board[position[0] + move[0]][position[1] + move[1]])
          moves.push(move)
        end
      end
    end
    moves
  end

  def create_black_king_move_list(moves, board, position)
    KING_MOVES.each do |move|
      if (position[0] + move[0]) >= 0 && (position[1] + move[1]) >= 0  && (position[0] + move[0] <= 7) && (position[1] + move[1] <= 7)
        if board[position[0] + move[0]][position[1] + move[1]] == " "
          moves.push(move)
        elsif WHITE_PIECES.include?(board[position[0] + move[0]][position[1] + move[1]])
          moves.push(move)
        end
      end
    end
    moves
  end

  def create_white_knight_move_list(moves, board, position)
    KNIGHT_MOVES.each do |move|
      if (position[0] + move[0]) >= 0 && (position[1] + move[1]) >= 0  && (position[0] + move[0] <= 7) && (position[1] + move[1] <= 7)
        if board[position[0] + move[0]][position[1] + move[1]] == " "
          moves.push(move)
        elsif BLACK_PIECES.include?(board[position[0] + move[0]][position[1] + move[1]])
          moves.push(move)
        end
      end
    end
    moves
  end

  def create_black_knight_move_list(moves, board, position)
    KNIGHT_MOVES.each do |move|
      if (position[0] + move[0]) >= 0 && (position[1] + move[1]) >= 0  && (position[0] + move[0] <= 7) && (position[1] + move[1] <= 7)
        if board[position[0] + move[0]][position[1] + move[1]] == " "
          moves.push(move)
        elsif WHITE_PIECES.include?(board[position[0] + move[0]][position[1] + move[1]])
          moves.push(move)
          stop = true
        end
      end
    end
    moves
  end

  def create_white_rook_move_list(moves, board, position)
    stop = false
    ROOK_ARRAY.each do |array|
      stop = false
      array.each do |move|
        if (position[0] + move[0]) < 0 || (position[1] + move[1]) < 0 || (position[0] + move[0] > 7) || (position[1] + move[1] > 7)
          stop = true
        end
        if stop == false && board[position[0] + move[0]][position[1] + move[1]] == " "
          moves.push(move)
        elsif stop == false && BLACK_PIECES.include?(board[position[0] + move[0]][position[1] + move[1]])
          moves.push(move)
          stop = true
        elsif stop == false && WHITE_PIECES.include?(board[position[0] + move[0]][position[1] + move[1]])
          stop = true
        end
      end
    end
    moves
  end

  def create_black_rook_move_list(moves, board, position)
    ROOK_ARRAY.each do |array|
      stop = false
      array.each do |move|
        if (position[0] + move[0]) < 0 || (position[1] + move[1]) < 0  || (position[0] + move[0] > 7) || (position[1] + move[1] > 7)
          stop = true
        end
        if stop == false && board[position[0] + move[0]][position[1] + move[1]] == " "
          moves.push(move)
        elsif stop == false && WHITE_PIECES.include?(board[position[0] + move[0]][position[1] + move[1]])
          moves.push(move)
          stop = true
        elsif stop == false && BLACK_PIECES.include?(board[position[0] + move[0]][position[1] + move[1]])
          stop = true
        end
      end
    end
    moves
  end

  def create_white_bishop_move_list(moves, board, position)
    stop = false
    BISHOP_ARRAY.each do |array|
      stop = false
      array.each do |move|
        if (position[0] + move[0]) < 0 || (position[1] + move[1]) < 0  || (position[0] + move[0] > 7) || (position[1] + move[1] > 7)
          stop = true
        end
        if stop == false && board[position[0] + move[0]][position[1] + move[1]] == " "
          moves.push(move)
        elsif stop == false && BLACK_PIECES.include?(board[position[0] + move[0]][position[1] + move[1]])
          moves.push(move)
          stop = true
        elsif stop == false && WHITE_PIECES.include?(board[position[0] + move[0]][position[1] + move[1]])
          stop = true
        end
      end
    end
    moves
  end

  def create_black_bishop_move_list(moves, board, position)
    stop = false
    BISHOP_ARRAY.each do |array|
      stop = false
      array.each do |move|
        if (position[0] + move[0]) < 0 || (position[1] + move[1]) < 0  || (position[0] + move[0] > 7) || (position[1] + move[1] > 7)
          stop = true
        end
        if stop == false && board[position[0] + move[0]][position[1] + move[1]] == " "
          moves.push(move)
        elsif stop == false && WHITE_PIECES.include?(board[position[0] + move[0]][position[1] + move[1]])
          moves.push(move)
          stop = true
        elsif stop == false && BLACK_PIECES.include?(board[position[0] + move[0]][position[1] + move[1]])
          stop = true
        end
      end
    end
    moves
  end

  def create_white_queen_move_list(moves, board, position)
    stop = false
    QUEEN_ARRAY.each do |array|
      stop = false
      array.each do |move|
        if (position[0] + move[0]) < 0 || (position[1] + move[1]) < 0  || (position[0] + move[0] > 7) || (position[1] + move[1] > 7)
          stop = true
        end
        if stop == false && board[position[0] + move[0]][position[1] + move[1]] == " "
          moves.push(move)
        elsif stop == false && BLACK_PIECES.include?(board[position[0] + move[0]][position[1] + move[1]])
          moves.push(move)
          stop = true
        elsif stop == false && WHITE_PIECES.include?(board[position[0] + move[0]][position[1] + move[1]])
          stop = true
        end
      end
    end
    moves
  end

  def create_black_queen_move_list(moves, board, position)
    stop = false
    QUEEN_ARRAY.each do |array|
      stop = false
      array.each do |move|
        if (position[0] + move[0]) < 0 || (position[1] + move[1]) < 0  || (position[0] + move[0] > 7) || (position[1] + move[1] > 7)
          stop = true
        end
        if stop == false && board[position[0] + move[0]][position[1] + move[1]] == " "
          moves.push(move)
        elsif stop == false && WHITE_PIECES.include?(board[position[0] + move[0]][position[1] + move[1]])
          moves.push(move)
          stop = true
        elsif stop == false && BLACK_PIECES.include?(board[position[0] + move[0]][position[1] + move[1]])
          stop = true
        end
      end
    end
    moves
  end
      

  def get_end_position_values(start_position, board, piece_value)
    end_positions_list = []
    move_list = create_move_list(piece_value, start_position, board)
    move_list.each do |move|
      row = start_position[0] + move[0]
      column = start_position[1] + move[1]
      end_positions_list.push(board[row][column])
    end
    end_positions_list
  end
end