require_relative "tile"

class Board
    def initialize
        @grid = Array.new(3, Array.new(3) { Tile.new } )
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

board = Board.new
p board.val([0,0])
board.set_val([0,0], "X")
p board.val([0,0])
p board.val([1,1])