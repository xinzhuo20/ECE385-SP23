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


module  color_mapper ( input        [9:0] BallX, BallY, DrawX, DrawY, Ball_size,
                       output logic [7:0]  Red, Green, Blue );
    
    logic ball_on;
	 logic [23:0] CharacterRGB;
	 logic [7:0] Address;

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
	  
    int DistX, DistY, Size, OffsetX, OffsetY;
	 assign DistX = DrawX - BallX;
    assign DistY = DrawY - BallY;
    assign Size = Ball_size;
    assign OffsetX = DrawX - BallX;
    assign OffsetY = DrawY - BallY; 
	 assign Address = DrawX + DrawY * 16;

	 
    always_comb
    begin:Ball_on_proc
        if ((OffsetX >= 0) && (OffsetX < 16) && (OffsetY >= 0) && (OffsetY < 16))
            ball_on = 1'b1;
        else 
            ball_on = 1'b0;
     end 
	  
	 
	 MarioROM Mario0 (.*);
	  
	  
	  
    always_comb
    begin:RGB_Display
        if (ball_on)
        begin 
            Red = CharacterRGB[7:0];
            Green = CharacterRGB[15:8];
            Blue = CharacterRGB[23:16];
        end
        else 
        begin 
            Red = 8'h00; 
            Green = 8'h00;
            Blue = 8'h7f - DrawX[9:3];
        end      
    end 
    
endmodule
