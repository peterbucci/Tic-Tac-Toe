class Player
    attr_reader :ai

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
end