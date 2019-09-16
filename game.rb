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
            pos = validate_and_parse(gets.chomp)
            board.set_val(pos, @whose_turn)
        end

        end_game
    end

    def validate_and_parse(user_input)
        if /^[0-2],[0-2]$/.match(user_input)
            pos = user_input.split(",").map(&:to_i)
            return pos if board.val(pos) == "*"

            message = "Someone already selected this square."
        else
            message = "Invalid input!"
        end

        board.render
        puts message
        puts ""
        puts "Please enter a *valid* position. e.g. 1,2"
        validate_and_parse(gets.chomp)
    end

    def win?
        rows = board.grid + board.grid.transpose + board.diagnols
        rows.any? { |row| row.all? { |tile| tile.value == @whose_turn } }
    end

    def end_game
        board.render
        puts "Game over"
        puts "\n#{@whose_turn} wins!"
        puts ""
    end
end

game = Game.new