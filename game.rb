require_relative "board"
require_relative "player"

class Game
    def initialize
        @board = Board.new
        @players = []
        until @players.length == 2
            @players << Player.setup(@players)
        end

        play
    end

    def play
        @players.shuffle!.each_with_index do |player, i| 
            i == 0 ? player.mark = "X" : player.mark = "O" 
        end

        @current_player = @players[0]

        until win?
            @current_player = @players.shift
            @players << @current_player
            board.render
            puts "Choose a position. e.g. 1,2"
            pos = parse_pos(gets.chomp)
            board.set_val(pos, @current_player.mark)
        end

        end_game
    end

    def parse_pos(user_input)
        if /^[0-2],[0-2]$/.match(user_input)
            pos = user_input.split(",").map(&:to_i)
            return pos if board.val(pos).empty?

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
        rows.any? { |row| row.all? { |tile| tile == @current_player.mark } }
    end

    def end_game
        board.render
        puts "Game over"
        puts "\n#{@current_player.name} wins!"
        puts ""
    end

    private
    attr_reader :board
end

Game.new