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
        @path_to_victory = []
    end

    def take_turn(current_node)
        if @ai
            if @path_to_victory.empty? || path_is_broken?(current_node)
                opponents_mark = @mark == "X" ? "O" : "X"
                endpoint = current_node.find_path(@mark, opponents_mark)
                @path_to_victory = current_node.build_path(endpoint)
            end

            @path_to_victory.shift
        else
            get_input(current_node)
        end
    end

    def get_input(current_node, message = "Choose a position. e.g. 1,2")
        puts message
        user_input = gets.chomp

        current_node.children.each do |child| 
            return child if child.prev_coord == user_input
        end

        puts ""
        get_input(current_node, "Invalid move!")
    end

    def path_is_broken?(current_node)
        if current_node.current_mark == @mark
            next_move = @path_to_victory[0].prev_coord
            !current_node.children.include?(next_move)
        else
            last_move = @path_to_victory.shift
            return false unless current_node.parent.prev_coord == last_move.prev_coord

            path_is_broken?(current_node)
        end
    end
end