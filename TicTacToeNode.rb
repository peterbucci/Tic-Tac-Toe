class TicTacToeNode
  attr_reader :children, :prev_coord, :board_state, :current_mark, :parent
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

  def find_path(mark, losing_mark)
    queue = [self]
    current_node = self

    no_winning_paths = mark == "X" ? current_node.x_wins_paths == 0 : current_node.o_wins_paths == 0

    until queue.empty?
      current_node = queue.shift
      return current_node if current_node.winning_node?(mark)

      current_node.children.each do |child|
        queue << child unless child.children.any? { |subchild| subchild.winning_node?(losing_mark) }
      end
    end

    unless @children.empty?
      return self.children.reject do |child| 
        child.children.any? { |subchild| subchild.winning_node?(losing_mark) }
      end.sample
    end
    
    return self.children.sample
  end

  def build_path(endpoint)
    current_node = endpoint
    winning_path = []

    until current_node == self
      winning_path << current_node

      current_node = current_node.parent
    end

    winning_path.reverse
  end
end