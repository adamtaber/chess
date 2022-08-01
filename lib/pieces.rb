class ChessPiece
  attr_reader :color

  def initialize(current_position, color)
    @current_position = current_position
    @color = color
    @initial_position = true
  end

  def moved?
    @initial_position == false
  end
end

class Pawn < ChessPiece
  def initialize
    @unicode_white = "\u2659"
    @unicode_black = "\u265f"
  end
end

class Rook < ChessPiece
  def initialize
    @unicode_white = "\u2656"
    @unicode_black = "\u265c"
  end
end

class Bishop < ChessPiece
  def initialize
    @unicode_white = "\u2657"
    @unicode_black = "\u265d"
  end

end

class Knight < ChessPiece
  def initialize
    @unicode_white = "\u2658"
    @unicode_black = "\u265e"
  end
end

class Queen < ChessPiece
  def initialize
    @unicode_white = "\u2655"
    @unicode_black = "\u265b"
  end

end

class King < ChessPiece
  def initialize
    @unicode_white = "\u2654"
    @unicode_black = "\u265a"
  end

end