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


module  color_mapper ( input        [9:0] BallX0, BallY0, BallX1, BallY1, DrawX, DrawY, Ball_size,
							  input logic [23:0] CharacterRGB0, CharacterRGB1,
							  input logic [7:0] Address0, Address1,
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
    assign OffsetX0 = DrawX - BallX0;
    assign OffsetY0 = DrawY - BallY0;
    assign OffsetX1 = DrawX - BallX1;
    assign OffsetY1 = DrawY - BallY1;
	 
//	 background baoguo (.back_address(BallY*640+BallX), .*);
	 
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
        if (ball_on0)
        begin 
            Red = CharacterRGB0[23:16];
            Green = CharacterRGB0[15:8];
            Blue = CharacterRGB0[7:0];
        end
		  
        else if (ball_on1)
        begin 
            Red = CharacterRGB1[23:16];
            Green = CharacterRGB1[15:8];
            Blue = CharacterRGB1[7:0];
        end
		  
        else 
        begin 
//            Red = BackgroundRGB[23:16];
//            Green = BackgroundRGB[15:8];
//            Blue = BackgroundRGB[7:0];
            {Red, Green, Blue} = {8'hFF, 8'hD7, 8'h00};
        end      
    end 
    
endmodule
