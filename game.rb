require_relative "board"

class Game
    attr_reader :board

    def initialize
        @board = Board.new
        @whose_turn = "X"

        take_turn
    end

    def take_turn
        until win?
            board.render
            puts "Choose a position."
            user_input = valid_pos?(gets.chomp)
            pos = parse_pos(user_input)
            board.set_val(pos, @whose_turn)
            @whose_turn == "X" ? @whose_turn = "O" : @whose_turn = "X"
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
        board.grid.any? { |row| row.all? { |tile| tile.value == "X" || tile.value =="O" } }
    end

    def end_game
        board.render
        puts "Game over!"
    end
end

game = Game.new