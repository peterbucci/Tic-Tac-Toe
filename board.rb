class Board
    attr_reader :grid

    def initialize
        @grid = Array.new(3) { Array.new(3, nil) }
    end

    def render
        puts "\e[H\e[2J"
        @grid.each_with_index do |row, i| 
            row_render = "#{i} | "
            row.each { |tile| row_render += "#{tile || "*"} " }
            puts row_render
        end
        puts "    - - -"
        puts "    #{(0...@grid.length).map(&:to_s).join(" ")}"
        puts ""
    end

    def diagnols
        [[@grid[0][0], @grid[1][1], @grid[2][2]],
            [@grid[2][0], @grid[1][1], @grid[0][2]]]
    end

    def val(pos)
        row, column = pos
        @grid[row][column]
    end

    def set_val(pos, new_val)
        row, column = pos
        @grid[row][column] = new_val
    end
end