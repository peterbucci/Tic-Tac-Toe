require_relative "tile"

class Board
    attr_reader :grid

    def initialize
        @grid = Array.new(3) { Array.new(3) { Tile.new } }
    end

    def render
        puts ""
        @grid.each_with_index do |row, i| 
            row_render = "#{i} | "
            row.each { |tile| row_render += "#{tile.value} " }
            puts row_render
        end
        puts "    - - -"
        puts "    #{(0...@grid.length).map(&:to_s).join(" ")}"
        puts ""
    end

    def diagnols
        [[@grid[0][0], @grid[1][1], @grid[2][2]],[@grid[2][0], @grid[1][1], @grid[0][2]]]
    end

    def val(pos)
        row, column = pos
        @grid[row][column].value
    end

    def set_val(pos, new_val)
        row, column = pos
        @grid[row][column].value = new_val
    end
end