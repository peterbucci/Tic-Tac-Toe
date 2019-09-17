require_relative "board"

class TicTacToeNode
  attr_reader :children, :prev_coord, :board_state
  attr_accessor :winning_paths, :losing_paths, :tied_paths

  def initialize(board, ai_mark, current_mark, parent = nil, prev_coord = nil)
    @board_state = board
    @ai_mark = ai_mark
    @current_mark = current_mark
    @parent = parent
    @prev_coord = prev_coord

    won = winning_node?(@board_state)
    lost = losing_node?(@board_state)
    
    won || lost ? @children = [] : @children = find_children
    won ? @winning_paths = 1 : @winning_paths = 0
    lost ? @losing_paths = 1 : @losing_paths = 0
    !won && !lost && @children.empty? ? @tied_paths = 1 : @tied_paths = 0

    @children.each do |child|
      @winning_paths = (child.winning_paths + @winning_paths)
      @losing_paths = (child.losing_paths + @losing_paths)
      @tied_paths = (child.tied_paths + @tied_paths)
    end

    @winning_paths = 0 if lost
    @tied_paths = 0 if lost
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
          children << TicTacToeNode.new(new_state, @ai_mark, next_mark, self, "#{i},#{j}")
        end
      end
    end

    children
  end

  def winning_node?(board)
    rows = board.grid + board.grid.transpose + board.diagnols
    rows.any? { |row| row.all? { |tile| tile == @ai_mark } }
  end

  def losing_node?(board)
    @ai_mark == "X" ? player_mark = "O" : player_mark = "X"
    rows = board.grid + board.grid.transpose + board.diagnols
    rows.any? { |row| row.all? { |tile| tile == player_mark } }
  end
end