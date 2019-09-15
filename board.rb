require_relative "tile"

class Board
    def initialize
        @grid = Array.new(3, Array.new(3) { Tile.new } )
    end

    def render
        puts "    #{(0...@grid.length).map(&:to_s).join(" ")}"
        @grid.each_with_index do |row, i| 
            row_render = "#{i} | "
            row.each { |tile| row_render += "#{tile.value} " }
            puts row_render
        end
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