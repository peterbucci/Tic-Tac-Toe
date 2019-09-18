require_relative "TicTacToeNode"

class Player
    attr_accessor :mark
    attr_reader :ai, :name

    @@current_node = nil

    def self.setup(players)
        n = (players.length + 1).to_s
        puts "\e[H\e[2J" + "What is player #{n}'s name?"
        name = gets.chomp

        return Player.new(name, false) if players[0] && players[0].ai == true

        puts "\e[H\e[2J" + "Is this player a computer?"
        user_input = gets.chomp.downcase

        until /(^yes$)|(^no$)/.match?(user_input)
            puts "\e[H\e[2J" + "Please enter yes or no"
            user_input = gets.chomp.downcase
        end

        user_input == "yes" ? ai = true : ai = false

        Player.new(name, ai)
    end

    def initialize(name, ai)
        @name = name
        @mark = nil
        @ai = ai
    end

    def take_turn(board)
        @@current_node = build_tree(board) if @@current_node.nil?

        @@current_node = @ai ? ai_move : human_move

        @@current_node.prev_coord
    end

    def human_move(message = "Choose a position. e.g. 1,2")
        puts message
        user_input = gets.chomp

        @@current_node.children.each do |child| 
            return child if child.prev_coord == user_input
        end

        puts ""
        human_move("Invalid move!")
    end

    def ai_move
        selected_move = nil

        @@current_node.children.each do |child| 
            selected_move = child if selected_move.nil?

            if no_winning_paths
                selected_move = child if child.tied_paths > selected_move.tied_paths
            else
                return child if child.winning_node?(@mark)
                selected_move = child if child.winning_paths > selected_move.winning_paths
            end
        end

        selected_move
    end

    def no_winning_paths
        @@current_node.children.all? { |child| child.winning_paths == 0 }
    end

    def build_tree(board)
        print "Building Game - Please Wait..." + "\r" + "\n"
        $stdout.flush
        ai_mark = @ai ? "X" : "O"
        TicTacToeNode.new(board, ai_mark, @mark)
    end
end