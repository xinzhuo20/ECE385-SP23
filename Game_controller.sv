module game_fsm (
    input wire Reset,
    input wire frame_clk,
    input wire character1_stepped,
    input wire character2_stepped,
    input wire start_game,
    output wire reg game_over
//	 output [1:0] li
);

    // State encoding
    typedef enum logic [1:0] {IDLE, PLAYING, GAME_OVER} state_t;
    state_t current_state, next_state;

    // Initial lives for both characters
    localparam int INITIAL_LIVES = 3;
    reg [2:0] character1_lives, character2_lives;

    // State transition logic
    always_comb begin
        next_state = current_state;
        case (current_state)
            IDLE: begin
                if (start_game)
                    next_state = PLAYING;
            end
            PLAYING: begin
                if (character1_lives == 0 || character2_lives == 0)
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
            character1_lives <= INITIAL_LIVES;
            character2_lives <= INITIAL_LIVES;
        end else begin
            current_state <= next_state;

            if (character1_stepped && current_state == PLAYING)
                character2_lives <= character2_lives - 1;
            if (character2_stepped && current_state == PLAYING)
                character1_lives <= character1_lives - 1;
        end
    end

    // Output logic
    assign game_over = (current_state == GAME_OVER);

endmodule
