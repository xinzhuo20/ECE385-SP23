//module collision_detection
//(
//input [9:0] x_0, x_1, y_0, y_1,
//output ball0_win, ball1_win
//);
//
////assign ball0_win = 0;
////assign ball1_win = 0;
//
//always_comb
//	begin
//		if (((x_1 - x_0) < 8 & (x_1 - x_0) > 0)| ((x_0 - x_1) < 8 & (x_0 - x_1) > 0))
//			if (y_0 - y_1 >= -16 & y_0 - y_1 <= 0)
//				ball0_win = 1;
//			else if (y_1 - y_0 >= -16 & y_1 - y_0 <= 0)
//				ball1_win = 1;
//			else
//				begin
//					ball0_win = 0;
//					ball1_win = 0;
//				end
//		else
//			begin
//					ball0_win = 0;
//					ball1_win = 0;
//			end
//	end
//
//	
//endmodule
module collision_detection
(
input [9:0] x_0, x_1, y_0, y_1,
input frame_clk,
output ball0_win, ball1_win
);


// Declare signed wires for signed values
wire signed [9:0] sx_0, sx_1, sy_0, sy_1;

// Assign input values to signed wires
assign sx_0 = x_0;
assign sx_1 = x_1;
assign sy_0 = y_0;
assign sy_1 = y_1;


always_comb
    begin
		  
        ball0_win = 0;
        ball1_win = 0;

        if (((sx_0 - sx_1 > -16) & (sx_0 - sx_1 <= -8)) | ((sx_0 - sx_1 > -8) & (sx_0 - sx_1 <= 0)) | ((sx_0 - sx_1 > 0) & (sx_0 - sx_1 <= 8)) | ((sx_0 - sx_1 > 8) & (sx_0 - sx_1 <= 16)))
			  begin
	//			if (((x_0 - x_1 >= -16) & (x_0 - x_1 < 0)) | ((x_0 - x_1 > 0) & (x_0 - x_1 <= 16)))
				  begin
						if ((y_0 - y_1 >= -16) & (y_0 - y_1 <= -8))
							 ball0_win = 1;
						else if ((y_1 - y_0 >= -16) & (y_1 - y_0 <= -8))
							 ball1_win = 1;
				  end

			  end
		end

endmodule