require 'colorize'

class ChessBoard
  attr_accessor :board

  def initialize
    @board = self.create_board
  end

  def create_board
    Array.new(8) { Array.new(8, " ") }
  end

  def print_board
    print "\n"
    board.each_with_index do |row, i|
      print "#{(i-8).abs} "
      if i%2 == 0
        row.each_with_index do |square, i|
          if i%2 == 0
            print " #{square.colorize(:black)} ".colorize(:background => :white)
          else
            print " #{square.colorize(:black)} ".colorize(:background => :cyan)
          end
        end
      elsif i%2 == 1
        row.each_with_index do |square, i|
          if i%2 == 0
            print " #{square.colorize(:black)} ".colorize(:background => :cyan)
          else
            print " #{square.colorize(:black)} ".colorize(:background => :white)
          end
        end
      end
      print "\n"
    end
    print "   a  b  c  d  e  f  g  h\n"
  end
end

test = ChessBoard.new
test.board[0][1] = "\u2656"
test.print_board