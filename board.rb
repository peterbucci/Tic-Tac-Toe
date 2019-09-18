class Board
    attr_reader :grid

    def initialize(grid = Array.new(3) { Array.new(3, "") })
        @grid = grid
    end

    def render
        grid.each_with_index do |row, i| 
            row_render = "#{i} | "
            row_render = "\e[H\e[2J" + row_render if i == 0

            row.each { |tile| row_render += "#{tile.empty? ? "*" : tile} " }
            puts row_render
        end

        puts "    - - -"
        puts "    #{(0...grid.length).map(&:to_s).join(" ")}"
        puts ""
    end

    def diagnols
        [[val([0,0]), val([1,1]), val([2,2])],
            [val([2,0]), val([1,1]), val([0,2])]]
    end

    def val(pos)
        row, column = pos
        grid[row][column]
    end

    def set_val(pos, new_val)
        row, column = pos
        @grid[row][column] = new_val
    end

    def clone
        new_grid = []
        @grid.each { |row| new_grid << row.clone }
        Board.new(new_grid)
    end
end