//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input clk, 
							  input [1:0] current_state_out,
							  input [2:0] character1_lives, character2_lives,
							  input        [9:0] BallX0, BallY0, BallX1, BallY1, DrawX, DrawY, Ball_size,
							  input logic [23:0] CharacterRGB0_left, CharacterRGB0_right, CharacterRGB1_left, CharacterRGB1_right,
							  input logic [7:0] Address0, Address1, keycode,
                       output logic [7:0] Red, Green, Blue,
							  output logic ball_on0, ball_on1,
							  output logic [11:0] OffsetX0, OffsetY0, OffsetX1, OffsetY1);
    

 /* Old Ball: Generated square box by checking if the current pixel is within a square of length
    2*Ball_Size, centered at (BallX, BallY).  Note that this requires unsigned comparisons.
	 
    if ((DrawX >= BallX - Ball_size) &&
       (DrawX <= BallX + Ball_size) &&
       (DrawY >= BallY - Ball_size) &&
       (DrawY <= BallY + Ball_size))

     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 12 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). */
	  
//	 logic [23:0] BackgroundRGB0;
//	 logic [23:0] BackgroundRGB1;
//    int DistX, DistY, Size;
//	 assign DistX = DrawX - BallX;
//    assign DistY = DrawY - BallY;
//    assign Size = Ball_size;
     `include "state_definition.sv"
	  
	 logic ch0_left, ch1_left, ch0_left_prev, ch1_left_prev;
	 logic [7:0] score1_r, score1_g, score1_b;
	 logic [7:0] score2_r, score2_g, score2_b;
	 logic [7:0] score3_r, score3_g, score3_b;
	 logic [7:0] score1r_r, score1r_g, score1r_b;
	 logic [7:0] score2r_r, score2r_g, score2r_b;
	 logic [7:0] score3r_r, score3r_g, score3r_b;
	 logic [7:0] score0_r, score0_g, score0_b;
	 logic [7:0] score0r_r, score0r_g, score0r_b;
	 logic [7:0] winr, wing, winb;

	 
	
	 logic is_scoreboard_area_left, is_scoreboard_area_right;
//    assign is_scoreboard_area = (DrawX >= SCOREBOARD_X_START) && (DrawX <= SCOREBOARD_X_END) && (DrawY >= SCOREBOARD_Y_START) && (DrawY <= SCOREBOARD_Y_END);
    
//	{score_r, score_g, score_b} = score_display(DrawX + (64 - DrawY) * 64);
	 assign OffsetX0 = DrawX - BallX0;
    assign OffsetY0 = DrawY - BallY0;
    assign OffsetX1 = DrawX - BallX1;
    assign OffsetY1 = DrawY - BallY1;

always_ff @(posedge clk)
begin
	is_scoreboard_area_left = 0;
	is_scoreboard_area_right = 0;
	if ((DrawX <= 64 & DrawY <= 64))
		is_scoreboard_area_left = 1;
	else if ((DrawX >= 575 & DrawY <= 64))
		is_scoreboard_area_right = 1;
end
	
zero_display score0 (.Address(DrawX + (64 - DrawY) * 64), .CharacterRGB({score0_r, score0_g, score0_b}));	
one_display score1 (.Address(DrawX + (64 - DrawY) * 64), .CharacterRGB({score1_r, score1_g, score1_b}));
two_display score2 (.Address(DrawX + (64 - DrawY) * 64), .CharacterRGB({score2_r, score2_g, score2_b}));
three_display score3 (.Address(DrawX + (64 - DrawY) * 64), .CharacterRGB({score3_r, score3_g, score3_b}));

zero_display scorer0 (.Address((DrawX - 575) + (64 - DrawY) * 64), .CharacterRGB({score0r_r, score0r_g, score0r_b}));
one_display scorer1 (.Address((DrawX - 575) + (64 - DrawY) * 64), .CharacterRGB({score1r_r, score1r_g, score1r_b}));
two_display scorer2 (.Address((DrawX - 575) + (64 - DrawY) * 64), .CharacterRGB({score2r_r, score2r_g, score2r_b}));
three_display scorer3 (.Address((DrawX - 575) + (64 - DrawY) * 64), .CharacterRGB({score3r_r, score3r_g, score3r_b}));
	
Saber_win Eastern_egg (.Address((DrawX - 251) + (285 - DrawY) * 136), .CharacterRGB({winr, wing, winb}), .left(!character2_lives));

	
//	 background baoguo (.back_address(BallY*640+BallX), .*);
always_ff @(posedge clk)
begin
    ch0_left_prev <= ch0_left;
    ch1_left_prev <= ch1_left;
end

always_comb
begin
    if (keycode[7])
        ch0_left <= 1;
    else if (keycode[5])
        ch0_left <= 0;
    else
        ch0_left <= ch0_left_prev;
end
		
always_comb
begin
    if (keycode[4])
        ch1_left <= 1;
    else if (keycode[2])
        ch1_left <= 0;
    else
        ch1_left <= ch1_left_prev;
end
		
		
		
		
    always_comb
    begin
        if ((OffsetX0 >= 0) && (OffsetX0 < 16) && (OffsetY0 >= 0) && (OffsetY0 < 16))
            ball_on0 = 1'b1;
        else 
            ball_on0 = 1'b0;	   
	 end
	
	 always_comb
	 begin
        if ((OffsetX1 >= 0) && (OffsetX1 < 16) && (OffsetY1 >= 0) && (OffsetY1 < 16))
            ball_on1 = 1'b1;
        else 
            ball_on1 = 1'b0;
    end 	

    always_comb
	 begin:RGB_Display
	if (DrawX >= 251 && DrawX <= 387 && DrawY >= 193 && DrawY <= 285 && current_state_out == GAME_OVER)
			{Red, Green, Blue} = {winr, wing, winb};			
	else
	 
    if (is_scoreboard_area_left)
    begin
        unique case (character1_lives)
            3'b000: {Red, Green, Blue} = {score0_r, score0_g, score0_b};
            3'b001: {Red, Green, Blue} = {score1_r, score1_g, score1_b};
            3'b010: {Red, Green, Blue} = {score2_r, score2_g, score2_b};
            3'b011: {Red, Green, Blue} = {score3_r, score3_g, score3_b};
            default: {Red, Green, Blue} = {score0_r, score0_g, score0_b}; // Set default color (black) for an unrecognized switch value
        endcase
    end
	 
	 else if (is_scoreboard_area_right)
    begin
        unique case (character2_lives)
            3'b000: {Red, Green, Blue} = {score0r_r, score0r_g, score0r_b};
            3'b001: {Red, Green, Blue} = {score1r_r, score1r_g, score1r_b};
            3'b010: {Red, Green, Blue} = {score2r_r, score2r_g, score2r_b};
            3'b011: {Red, Green, Blue} = {score3r_r, score3r_g, score3r_b};
            default: {Red, Green, Blue} = {score0r_r, score0r_g, score0r_b}; // Set default color (black) for an unrecognized switch value
        endcase
    end
	 
	 else
	  
	 
//	 Following code are characters and backgrounds.
        if (ball_on0)
        begin
				if (ch0_left)
					{Red, Green, Blue} = {CharacterRGB0_left[23:16], CharacterRGB0_left[15:8], CharacterRGB0_left[7:0]};
				else
					{Red, Green, Blue} = {CharacterRGB0_right[23:16], CharacterRGB0_right[15:8], CharacterRGB0_right[7:0]};
        end
		  
        else if (ball_on1)
        begin 
				if (ch1_left)
					{Red, Green, Blue} = {CharacterRGB1_left[23:16], CharacterRGB1_left[15:8], CharacterRGB1_left[7:0]};
				else
					{Red, Green, Blue} = {CharacterRGB1_right[23:16], CharacterRGB1_right[15:8], CharacterRGB1_right[7:0]};

        end

		  
        else 
        begin 
            {Red, Green, Blue} = {8'hFF, 8'hD7, 8'h00};
        end      
    end 
    
endmodule


