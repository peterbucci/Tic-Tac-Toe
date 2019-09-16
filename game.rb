require_relative "board"

class Game
    attr_reader :board

    def initialize
        @board = Board.new
        @whose_turn = "O"

        take_turn
    end

    def take_turn
        until win?
            @whose_turn == "X" ? @whose_turn = "O" : @whose_turn = "X"
            board.render
            puts "Choose a position."
            user_input = valid_pos?(gets.chomp)
            pos = parse_pos(user_input)
            board.set_val(pos, @whose_turn)
        end

        end_game
    end

    def valid_pos?(input)
        input
    end

    def parse_pos(input)
        input.split(",").map(&:to_i)
    end

    def win?
        rows = board.grid + board.grid.transpose + board.diagnols
        rows.any? { |row| row.all? { |tile| tile.value == @whose_turn } }
    end

    def end_game
        board.render
        puts "Game over!"
        puts "#{@whose_turn} wins!"
    end
end

game = Game.new