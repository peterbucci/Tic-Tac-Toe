# Idea: To search for the fatest path to victory that comes before a loss.
# build an array of pos and have the ai follow the array unless the user breaks
# the array pattern that was created. If this happens rebuilding the array of pos
# and have the ai follow that new path

class TicTacToeNode
  attr_reader :children, :prev_coord, :board_state
  attr_accessor :x_wins_paths, :o_wins_paths, :tied_paths

  def initialize(board, current_mark, parent = nil, prev_coord = nil)
    @board_state = board
    @current_mark = current_mark
    @parent = parent
    @prev_coord = prev_coord

    x_wins = winning_node?("X")
    o_wins = winning_node?("O")

    @children = x_wins || o_wins ? [] : find_children
    @x_wins_paths = x_wins ? 1 : 0
    @o_wins_paths = o_wins ? 1 : 0
    @tied_paths = !x_wins && !o_wins && @children.empty? ? 1 : 0

    add_child_paths
  end

  def find_children
    children = []

    @board_state.grid.each_with_index do |row, i|
      row.each_with_index do |square, j|
        if square.empty?
          new_state = @board_state.clone
          new_state.set_val([i, j], @current_mark)

          @current_mark == "X" ? next_mark = "O" : next_mark = "X"
          children << TicTacToeNode.new(new_state, next_mark, self, "#{i},#{j}")
        end
      end
    end

    children
  end

  def winning_node?(mark)
    rows = @board_state.grid + @board_state.grid.transpose + @board_state.diagnols
    rows.any? { |row| row.all? { |tile| tile == mark } }
  end

  def add_child_paths
    @children.each do |child|
      @x_wins_paths = (child.x_wins_paths + @x_wins_paths)
      @o_wins_paths = (child.o_wins_paths + @o_wins_paths)
      @tied_paths = (child.tied_paths + @tied_paths)
    end
  end
end