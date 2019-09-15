require_relative "board"

class Game
    attr_reader :board

    def initialize
        @board = Board.new

        take_turn
    end

    def take_turn
        until win?
            board.render
            puts "\n" + "Choose a position."
            user_input = gets.chomp
        end

        end_game
    end

    def win?
        false
    end

    def end_game
    end
end

game = Game.new
p game.board.val([0,0])
game.board.set_val([0,0], "X")
p game.board.val([0,0])
p game.board.val([1,1])