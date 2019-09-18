class TicTacToeNode
  attr_reader :children, :prev_coord, :board_state
  attr_accessor :winning_paths, :losing_paths, :tied_paths

  def initialize(board, ai_mark, current_mark, parent = nil, prev_coord = nil)
    @board_state = board
    @ai_mark = ai_mark
    @current_mark = current_mark
    @parent = parent
    @prev_coord = prev_coord

    won = winning_node?(@ai_mark)
    @ai_mark == "X" ? player_mark = "O" : player_mark = "X"
    lost = winning_node?(player_mark)

    @children = won || lost ? [] : find_children
    @winning_paths = won ? 1 : 0
    @losing_paths = lost ? 1 : 0
    @tied_paths = !won && !lost && @children.empty? ? 1 : 0

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
          children << TicTacToeNode.new(new_state, @ai_mark, next_mark, self, "#{i},#{j}")
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
      @winning_paths = (child.winning_paths + @winning_paths)
      @losing_paths = (child.losing_paths + @losing_paths)
      @tied_paths = (child.tied_paths + @tied_paths)
    end
  end
end