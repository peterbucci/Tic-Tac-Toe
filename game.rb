require_relative "board"
require_relative "player"

class Game
    def initialize
        @board = Board.new
        @players = []
        @players << Player.setup(@players) until @players.length == 2

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

            user_input = @current_player.take_turn(board.clone)
            pos = user_input.split(",").map(&:to_i)
            
            board.set_val(pos, @current_player.mark)
        end

        end_game
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