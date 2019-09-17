require_relative "TicTacToeNode"

class Player
    attr_accessor :mark
    attr_reader :ai, :name

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
        @current_move = nil
    end

    def take_turn(board)
        build_tree(board) if @current_move.nil?
        move_tree(board) unless @current_move.board_state.grid == board.grid
        if @current_move.children.all? { |child| child.winning_paths == 0 }
            select_tie_move
        else
            select_move
        end
    end
    
    def move_tree(board)
        @current_move.children.each do |child|
            @current_move = child if child.board_state.grid == board.grid
        end
    end

    def select_move
        selected_move = nil
        @current_move.children.each do |child| 
            if child.winning_node?(child.board_state)
                return child.prev_coord
            elsif selected_move.nil? || child.winning_paths > selected_move.winning_paths
                selected_move = child
            end
        end

        @current_move = selected_move
        selected_move.prev_coord
    end

    def select_tie_move
        selected_move = nil
        @current_move.children.each do |child| 
            if child.winning_node?(child.board_state)
                return child.prev_coord
            elsif selected_move.nil? || child.tied_paths > selected_move.tied_paths
                selected_move = child
            end
        end

        @current_move = selected_move
        selected_move.prev_coord
    end

    def build_tree(board)
        @current_move = TicTacToeNode.new(board, @mark, @mark)
    end
end