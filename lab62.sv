//-------------------------------------------------------------------------
//                                                                       --
//                                                                       --
//      For use with ECE 385 Lab 62                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module lab62 (

      ///////// Clocks /////////
      input     MAX10_CLK1_50, 

      ///////// KEY /////////
      input    [ 1: 0]   KEY,

      ///////// SW /////////
      input    [ 9: 0]   SW,

      ///////// LEDR /////////
      output   [ 9: 0]   LEDR,

      ///////// HEX /////////
      output   [ 7: 0]   HEX0,
      output   [ 7: 0]   HEX1,
      output   [ 7: 0]   HEX2,
      output   [ 7: 0]   HEX3,
      output   [ 7: 0]   HEX4,
      output   [ 7: 0]   HEX5,

      ///////// SDRAM /////////
      output             DRAM_CLK,
      output             DRAM_CKE,
      output   [12: 0]   DRAM_ADDR,
      output   [ 1: 0]   DRAM_BA,
      inout    [15: 0]   DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_UDQM,
      output             DRAM_CS_N,
      output             DRAM_WE_N,
      output             DRAM_CAS_N,
      output             DRAM_RAS_N,

      ///////// VGA /////////
      output             VGA_HS,
      output             VGA_VS,
      output   [ 3: 0]   VGA_R,
      output   [ 3: 0]   VGA_G,
      output   [ 3: 0]   VGA_B,


      ///////// ARDUINO /////////
      inout    [15: 0]   ARDUINO_IO,
      inout              ARDUINO_RESET_N 

);




logic Reset_h, vssig, blank, sync, VGA_Clk;


//=======================================================
//  REG/WIRE declarations
//=======================================================
	logic SPI0_CS_N, SPI0_SCLK, SPI0_MISO, SPI0_MOSI, USB_GPX, USB_IRQ, USB_RST;
	logic [3:0] hex_num_4, hex_num_3, hex_num_1, hex_num_0; //4 bit input hex digits
	logic [1:0] signs;
	logic [1:0] hundreds;
	logic [9:0] drawxsig, drawysig, ballxsig0, ballysig0, ballxsig1, ballysig1, ballsizesig;
	logic [7:0] Red, Blue, Green;
	logic [7:0] keycode;

//=======================================================
//  Structural coding
//=======================================================
	assign ARDUINO_IO[10] = SPI0_CS_N;
	assign ARDUINO_IO[13] = SPI0_SCLK;
	assign ARDUINO_IO[11] = SPI0_MOSI;
	assign ARDUINO_IO[12] = 1'bZ;
	assign SPI0_MISO = ARDUINO_IO[12];
	
	assign ARDUINO_IO[9] = 1'bZ; 
	assign USB_IRQ = ARDUINO_IO[9];
		
	//Assignments specific to Circuits At Home UHS_20
	assign ARDUINO_RESET_N = USB_RST;
	assign ARDUINO_IO[7] = USB_RST;//USB reset 
	assign ARDUINO_IO[8] = 1'bZ; //this is GPX (set to input)
	assign USB_GPX = 1'b0;//GPX is not needed for standard USB host - set to 0 to prevent interrupt
	
	//Assign uSD CS to '1' to prevent uSD card from interfering with USB Host (if uSD card is plugged in)
	assign ARDUINO_IO[6] = 1'b1;
	
	//HEX drivers to convert numbers to HEX output
	HexDriver hex_driver4 (hex_num_4, HEX4[6:0]);
	assign HEX4[7] = 1'b1;
	
	HexDriver hex_driver3 (hex_num_3, HEX3[6:0]);
	assign HEX3[7] = 1'b1;
	
	HexDriver hex_driver1 (hex_num_1, HEX1[6:0]);
	assign HEX1[7] = 1'b1;
	
	HexDriver hex_driver0 (hex_num_0, HEX0[6:0]);
	assign HEX0[7] = 1'b1;
	
	//fill in the hundreds digit as well as the negative sign
	assign HEX5 = {1'b1, ~signs[1], 3'b111, ~hundreds[1], ~hundreds[1], 1'b1};
	assign HEX2 = {1'b1, ~signs[0], 3'b111, ~hundreds[0], ~hundreds[0], 1'b1};
	
	
	//Assign one button to reset
	assign {Reset_h}=~ (KEY[0]);

	//Our A/D converter is only 12 bit
	assign VGA_R = (~blank) ? 4'h0 : Red[7:4];
	assign VGA_B = (~blank) ? 4'h0 : Blue[7:4];
	assign VGA_G = (~blank) ? 4'h0 : Green[7:4];

	
//assign Address0 = (ball_on0) ? ((16 - OffsetY0) * 16) + OffsetX0 : 8'b0;
//assign Address1 = (ball_on1) ? ((16 - OffsetY1) * 16) + OffsetX1 : 8'b0;
	
	lab62_soc u0 (
		.clk_clk                           (MAX10_CLK1_50),  //clk.clk
		.reset_reset_n                     (1'b1),           //reset.reset_n
		.altpll_0_locked_conduit_export    (),               //altpll_0_locked_conduit.export
		.altpll_0_phasedone_conduit_export (),               //altpll_0_phasedone_conduit.export
		.altpll_0_areset_conduit_export    (),               //altpll_0_areset_conduit.export
		.key_external_connection_export    (KEY),            //key_external_connection.export

		//SDRAM
		.sdram_clk_clk(DRAM_CLK),                            //clk_sdram.clk
		.sdram_wire_addr(DRAM_ADDR),                         //sdram_wire.addr
		.sdram_wire_ba(DRAM_BA),                             //.ba
		.sdram_wire_cas_n(DRAM_CAS_N),                       //.cas_n
		.sdram_wire_cke(DRAM_CKE),                           //.cke
		.sdram_wire_cs_n(DRAM_CS_N),                         //.cs_n
		.sdram_wire_dq(DRAM_DQ),                             //.dq
		.sdram_wire_dqm({DRAM_UDQM,DRAM_LDQM}),              //.dqm
		.sdram_wire_ras_n(DRAM_RAS_N),                       //.ras_n
		.sdram_wire_we_n(DRAM_WE_N),                         //.we_n

		//USB SPI	
		.spi0_SS_n(SPI0_CS_N),
		.spi0_MOSI(SPI0_MOSI),
		.spi0_MISO(SPI0_MISO),
		.spi0_SCLK(SPI0_SCLK),
		
		//USB GPIO
		.usb_rst_export(USB_RST),
		.usb_irq_export(USB_IRQ),
		.usb_gpx_export(USB_GPX),
		
		//LEDs and HEX
		.hex_digits_export({hex_num_4, hex_num_3, hex_num_1, hex_num_0}),
		.leds_export({hundreds, signs, LEDR}),
		.keycode_export(keycode),
	 );

	 `include "state_definition.sv"

//instantiate a vga_controller, ball, and color_mapper here with the ports.

game_fsm (.Reset(Reset_h), .frame_clk(VGA_VS), .character1_stepped(ball0_win), .character2_stepped(ball1_win), .start_game(~KEY[1]), .*);


collision_detection (.*, .frame_clk(VGA_VS), .x_0(ballxsig0), .x_1(ballxsig1), .y_0(ballysig0), .y_1(ballysig1));
												  											  
vga_controller vga0 (.*, .Clk (MAX10_CLK1_50), .Reset (Reset_h), .hs (VGA_HS), .vs (VGA_VS), .pixel_clk(VGA_CLK), .DrawX (drawxsig), .DrawY (drawysig));

ball0 ball0 (.*, .Reset (Reset_h), .die(ball1_win), .frame_clk (VGA_VS), .keycode (keycode), .BallX (ballxsig0), .BallY (ballysig0), .BallS (ballsizesig));

ball1 ball1 (.*, .Reset (Reset_h), .die(ball0_win), .frame_clk (VGA_VS), .keycode (keycode), .BallX (ballxsig1), .BallY (ballysig1), .BallS (ballsizesig));

color_mapper cm0 (.*, .clk(MAX10_CLK1_50), .BallX0 (ballxsig0), .BallY0 (ballysig0), .BallX1 (ballxsig1), .BallY1 (ballysig1), .DrawX (drawxsig), .DrawY (drawysig), .Ball_size (ballsizesig));


logic [2:0] character1_lives, character2_lives;
logic [1:0] current_state_out;
logic [7:0] Address0, Address1;
logic [11:0] OffsetX0, OffsetY0, OffsetX1, OffsetY1;
//logic [8:0] PixelData0, PixelData1;
logic ball_on0, ball_on1, ball0_win, ball1_win, game_over;
logic [23:0] CharacterRGB0_left, CharacterRGB0_right, CharacterRGB1_left, CharacterRGB1_right;

MarioROM_left Mario0_left (.Address(Address0),.CharacterRGB(CharacterRGB0_left),.switch(SW[9]));

MarioROM_left Mario1_left (.Address(Address1),.CharacterRGB(CharacterRGB1_left),.switch(SW[8]));

MarioROM_right Mario0_right (.Address(Address0),.CharacterRGB(CharacterRGB0_right),.switch(SW[9]));

MarioROM_right Mario1_right (.Address(Address1),.CharacterRGB(CharacterRGB1_right),.switch(SW[8]));


// Calculate the Address based on OffsetX and OffsetY
// Facing left side
assign Address0 = (ball_on0) ? ((16 - OffsetY0) * 16) + OffsetX0 : 8'b0;
assign Address1 = (ball_on1) ? ((16 - OffsetY1) * 16) + OffsetX1 : 8'b0;

//assign Address = (ball_on) ? ((16 - OffsetY) * 16) + (16 - OffsetX) : 8'b0;


endmodule
