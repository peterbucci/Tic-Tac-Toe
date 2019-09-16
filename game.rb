require_relative "board"
require_relative "player"

class Game
    def initialize
        @board = Board.new
        @players = []
        until @players.length == 2
            @players << Player.setup(@players)
        end
        @whose_turn = "O"
        p @players
        sleep(2)

        take_turn
    end

    def take_turn
        until win?
            @whose_turn == "X" ? @whose_turn = "O" : @whose_turn = "X"
            board.render
            puts "Choose a position. e.g. 1,2"
            pos = parse_pos(gets.chomp)
            board.set_val(pos, @whose_turn)
        end

        end_game
    end

    def parse_pos(user_input)
        if /^[0-2],[0-2]$/.match(user_input)
            pos = user_input.split(",").map(&:to_i)
            return pos unless board.val(pos)

            message = "Someone already selected this square."
        else
            message = "Invalid input!"
        end

        board.render
        puts message
        puts "\n" + "Please enter a *valid* position. e.g. 1,2"
        parse_pos(gets.chomp)
    end

    def win?
        rows = board.grid + board.grid.transpose + board.diagnols
        rows.any? { |row| row.all? { |tile| tile == @whose_turn } }
    end

    def end_game
        board.render
        puts "Game over"
        puts "\n#{@whose_turn} wins!"
        puts ""
    end

    private
    attr_reader :board
end

Game.new