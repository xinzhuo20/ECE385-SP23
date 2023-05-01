module game_fsm (
    input Reset,
    input frame_clk,
    input character1_stepped,
    input character2_stepped,
    input start_game,
    output game_over,
    output logic [2:0] character1_lives,
    output logic [2:0] character2_lives,
    output logic [1:0] current_state_out
);

     `include "state_definition.sv"

    // State encoding

	  state_t current_state, next_state;

    // Initial lives for both characters
    localparam int INITIAL_LIVES = 3;
    reg [2:0] character1_lives_reg, character2_lives_reg;

    // State transition logic
    always_comb begin
        next_state = current_state;
        case (current_state)
            IDLE: begin
                if (start_game)
                    next_state = PLAYING;
            end
            PLAYING: begin
                if (character1_lives_reg == 0 || character2_lives_reg == 0)
                    next_state = GAME_OVER;
            end
            GAME_OVER: begin
                if (Reset)
                    next_state = IDLE;
            end
        endcase
    end

    // State register and lives update
    always_ff @(posedge frame_clk or posedge Reset) begin
        if (Reset) begin
            current_state <= IDLE;
            character1_lives_reg <= INITIAL_LIVES;
            character2_lives_reg <= INITIAL_LIVES;
        end else begin
            current_state <= next_state;

            if (character1_stepped && current_state == PLAYING)
                character2_lives_reg <= character2_lives_reg - 1;
            if (character2_stepped && current_state == PLAYING)
                character1_lives_reg <= character1_lives_reg - 1;
        end
    end

    // Output logic
    assign game_over = (current_state == GAME_OVER);
    assign character1_lives = character1_lives_reg;
    assign character2_lives = character2_lives_reg;
    assign current_state_out = current_state;

endmodule
