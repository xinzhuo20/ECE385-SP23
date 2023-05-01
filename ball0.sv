//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 298 Lab 7                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball0 ( input Reset, frame_clk, die,
					input [1:0] current_state_out,
					input [7:0] keycode,
               output [9:0]  BallX, BallY, BallS );
    
	 `include "state_definition.sv"
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion, Ball_Size;
	 
	 int Initial_velocity = -10;
	 logic [2:0] gravity = 1;
	 
    parameter [9:0] Ball_X_Center=100;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center=463;  // Center position on the Y axis  463
    parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=463;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis
	 parameter [9:0] ATM_field = 18;     // Max distance between characters and wall.

    assign Ball_Size = 16;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
   
	
	 assign gravity = (keycode[1]) ? 0 : 1;

	 
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Ball
        if (Reset)  // Asynchronous Reset
        begin 
            Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
				Ball_X_Motion <= 10'd0; //Ball_X_Step;
				Ball_Y_Pos <= Ball_Y_Center;
				Ball_X_Pos <= Ball_X_Center;
				
				
				
				// Used when the fram_clk is not proper for achieving the function
//				update_counter <= update_counter + 1;
//				if (update_counter >=  2000000)
//					begin
//						update_counter <= 0;

						
        end
           
		  else if (die)
			begin
				Ball_Y_Pos <= Ball_Y_Center;
				Ball_X_Pos <= Ball_X_Center;
			end
			
        else 
        begin 
		  
		  // Not neccessary
//				 if ( (Ball_Y_Pos + Ball_Size) >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
//					begin
//					  Ball_Y_Motion <= 0;
////					  Ball_X_Motion <= 0;
//					end
				 if (Ball_Y_Pos >= Ball_Y_Max)  // Ball is at the bottom edge, do not get in!
					begin
					  Ball_Y_Motion <= 0;
					  Ball_Y_Pos <= Ball_Y_Max;
					end
				  else if ( Ball_X_Pos >= Ball_X_Max - ATM_field)  // Ball is at the Right edge, BOUNCE!
				   begin
					  Ball_X_Motion <= 0;
					  Ball_X_Pos <= Ball_X_Max;
					end 
				 else if ( Ball_X_Pos <= Ball_X_Min + ATM_field)  // Ball is at the Left edge, BOUNCE!
				  begin
					  Ball_X_Motion <= 0;
					  Ball_X_Pos <= Ball_X_Min;
				  end
					  
					  
				 else 
					  Ball_Y_Motion <= Ball_Y_Motion;  // Ball is somewhere in the middle, don't bounce, just keep moving
					  
				 
//				 case (keycode)
//					8'h80 : begin
//							  if (Ball_X_Pos > Ball_X_Min + ATM_field)
//									Ball_X_Motion <= -1;//A
//							  else
//									Ball_X_Motion <= 0;
//								end
//							  
//					        
//					8'h07 : begin
//							  if (Ball_X_Pos < Ball_X_Max - ATM_field)
//									Ball_X_Motion <= 1;//D
//							  else
//									Ball_X_Motion <= 0;
//							  end
//							  
//							 
//					8'h : begin
//								if (Ball_Y_Pos == Ball_Y_Max) //W
//									Ball_Y_Motion <= Initial_velocity;
//							  end
					
					
					
					if (keycode[7] == 1)
						if (Ball_X_Pos > Ball_X_Min + ATM_field)
							Ball_X_Motion <= -1;//A
						else
							Ball_X_Motion <= 0;							
						
					if (keycode[5] == 1)
						if (Ball_X_Pos < Ball_X_Max - ATM_field)
							Ball_X_Motion <= 1;//D
						else
							Ball_X_Motion <= 0;
							
						
					if (keycode[6] == 1)
						if (Ball_Y_Pos == Ball_Y_Max)
							Ball_Y_Motion <= Initial_velocity;
					
					if (~(keycode[7] | keycode[5]))
						Ball_X_Motion <= 0;
						
						
//					default:
//						begin
//							Ball_X_Motion <= 0;
//						end
//							
//			   endcase
				 
				 if (Ball_Y_Pos < Ball_Y_Max)
					Ball_Y_Motion <= Ball_Y_Motion + gravity;
				 
			 
				 if (Ball_Y_Pos + Ball_Y_Motion <= Ball_Y_Max && current_state_out == PLAYING)
					Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
				 else
					Ball_Y_Pos <= Ball_Y_Max;
				
				 if (current_state_out == PLAYING)
					Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
			
			
	  /**************************************************************************************
	    ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
		 Hidden Question #2/2:
          Note that Ball_Y_Motion in the above statement may have been changed at the same clock edge
          that is causing the assignment of Ball_Y_pos.  Will the new value of Ball_Y_Motion be used,
          or the old?  How will this impact behavior of the ball during a bounce, and how might that 
          interact with a response to a keypress?  Can you fix it?  Give an answer in your Post-Lab.
      **************************************************************************************/
      
			
		end  
    end
     
	  
		assign	BallX = Ball_X_Pos;
   
		assign 	BallY = Ball_Y_Pos;

		assign	BallS = Ball_Size;
    

endmodule
