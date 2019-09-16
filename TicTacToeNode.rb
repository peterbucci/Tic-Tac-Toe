class TicTacToeNode
    def initialize(state, player, prev_pos = nil)
        @game_state = state
        @next_mover_mark = player
        @prev_move_pos = prev_pos
    end
end