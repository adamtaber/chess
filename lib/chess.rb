require 'colorize'
require_relative '../lib/pieces'

class ChessBoard
  attr_accessor :board

  BLACK = {rook: "\u265c", knight: "\u265e", bishop: "\u265d", queen: "\u265b", king: "\u265a", pawn: "\u265f"}
  WHITE = {rook: "\u2656", knight: "\u2658", bishop: "\u2657", queen: "\u2655", king: "\u2654", pawn: "\u2659"}

  def initialize
    @board = self.create_board
  end

  def create_board
    temp_board = Array.new(8) { Array.new(8, " ") }
    self.fill_board(temp_board)
    temp_board
  end

  def fill_board(temp_board)
    temp_board.each_with_index do |arr, i|
      if i == 0
        row = temp_board[i]
        row.each_with_index do |square, i|
          case i
          when 0
            row[i] = BLACK[:rook]
          when 1
            row[i] = BLACK[:knight]
          when 2
            row[i] = BLACK[:bishop]
          when 3
            row[i] = BLACK[:queen]
          when 4
            row[i] = BLACK[:king]
          when 5
            row[i] = BLACK[:bishop]
          when 6
            row[i] = BLACK[:knight]
          when 7
            row[i] = BLACK[:rook]
          end
        end
        temp_board[0] = row
      elsif i == 1
        row = temp_board[i]
        row.each_index do |i|
          row[i] = BLACK[:pawn]
        end
        temp_board[1] = row
      elsif i == 6
        row = temp_board[i]
        row.each_index do |i|
          row[i] = WHITE[:pawn]
        end
        temp_board[6] = row
      elsif i == 7
        row = temp_board[i]
        row.each_with_index do |square, i|
          case i
          when 0
            row[i] = WHITE[:rook]
          when 1
            row[i] = WHITE[:knight]
          when 2
            row[i] = WHITE[:bishop]
          when 3
            row[i] = WHITE[:queen]
          when 4
            row[i] = WHITE[:king]
          when 5
            row[i] = WHITE[:bishop]
          when 6
            row[i] = WHITE[:knight]
          when 7
            row[i] = WHITE[:rook]
          end
        end
        temp_board[7] = row
      end
    end
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

  def opposite_color?(piece, turn)
    if turn % 2 == 0
      BLACK.has_value?(piece)
    elsif turn % 2 == 1
      WHITE.has_value?(piece)
    end
  end
end

test = ChessBoard.new
test.print_board