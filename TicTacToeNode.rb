require_relative "board"

class TicTacToeNode
  attr_reader :children
  attr_accessor :winning_paths, :losing_paths, :tied_paths

  def initialize(board, mark, parent = nil)
    @board_state = board
    won = winning_node?(@board_state)
    lost = losing_node?(@board_state)

    @current_mark = mark
    @parent = parent
    won || lost ? @children = [] : @children = find_children
    won ? @winning_paths = 1 : @winning_paths = 0
    lost ? @losing_paths = 1 : @losing_paths = 0
    !won && !lost && @children.empty? ? @tied_paths = 1 : @tied_paths = 0

    @children.each do |child|
      @winning_paths = (child.winning_paths + @winning_paths)
      @losing_paths = (child.losing_paths + @losing_paths)
      @tied_paths = (child.tied_paths + @tied_paths)
    end
  end

  def find_children
    children = []
    
    @board_state.grid.each_with_index do |row, i|
      row.each_with_index do |square, j|
        if square.empty?
          new_grid = []
          @board_state.grid.each { |row| new_grid << row.clone }
          new_state = Board.new(new_grid)
          new_state.set_val([i, j], @current_mark)

          @current_mark == "X" ? next_mark = "O" : next_mark = "X"
          children << TicTacToeNode.new(new_state, next_mark, self)
        end
      end
    end

    children
  end

  def winning_node?(board)
    rows = board.grid + board.grid.transpose + board.diagnols
    rows.any? { |row| row.all? { |tile| tile == "X" } }
  end

  def losing_node?(board)
    rows = board.grid + board.grid.transpose + board.diagnols
    rows.any? { |row| row.all? { |tile| tile == "O" } }
  end
end

board = Board.new
node = TicTacToeNode.new(board, "X")
p node.winning_paths
p node.losing_paths
p node.tied_paths