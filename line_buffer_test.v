`timescale 1ns / 1ps

module line_buffer_test;

	// Inputs
	reg PIXCLK;
	reg LINE_VALID;
	reg FRAME_VALID;
	reg [9:0] DATA_IN;

	// Outputs
	wire [9:0] CAMERA_DATA_OUT;
	wire [1:0] CURRENT_LINE;
	wire [0:0] CURRENT_COLUMN;
	wire PIXEL_VALID;

	// Instantiate the Unit Under Test (UUT)
	camera #(3,2) uut1 (
		.PIXCLK(PIXCLK), 
		.LINE_VALID(LINE_VALID), 
		.FRAME_VALID(FRAME_VALID), 
		.DATA_IN(DATA_IN), 
		.DATA_OUT(CAMERA_DATA_OUT), 
		.CURRENT_LINE(CURRENT_LINE), 
		.CURRENT_COLUMN(CURRENT_COLUMN), 
		.PIXEL_VALID(PIXEL_VALID)
	);


	// New inputs
	reg CLK;
	reg [0:0] INTERESTING_LINE;
	reg [0:0] READ_ADDRESS;
	reg RESET_READY_FLAG;

	// Outputs
	wire WHOLE_LINE_READY_FLAG;
	wire [9:0] DATA_OUT;

	// Instantiate the Unit Under Test (UUT)
	line_buffer #(3,2) uut2 (
		.CLK(CLK), 
		.VALID_DATA(PIXEL_VALID), 
		.CURRENT_COLUMN(CURRENT_COLUMN), 
		.CURRENT_LINE(CURRENT_LINE), 
		.INTERESTING_LINE(1), //Line #1 
		.DATA_IN(CAMERA_DATA_OUT), 
		.READ_ADDRESS(READ_ADDRESS), 
		.RESET_READY_FLAG(RESET_READY_FLAG), 
		.WHOLE_LINE_READY_FLAG(WHOLE_LINE_READY_FLAG), 
		.DATA_OUT(DATA_OUT)
	);


	initial begin
		// Initialize Inputs
		
		PIXCLK = 0;
		INTERESTING_LINE = 1;
		DATA_IN = 0;
		READ_ADDRESS = 1'bX;
		RESET_READY_FLAG = 0;

	end
	
	
	initial begin
		// Initialize Inputs
		CLK = 1;
		PIXCLK = 0;
		LINE_VALID = 1;
		FRAME_VALID = 1;
		DATA_IN = 0;
		// Test ignoring of random already ongoing frame
		#42;
		forever
		begin
			LINE_VALID = 0;
			FRAME_VALID = 0;
			#20;
			
			FRAME_VALID = 1;
			#10;
			
			LINE_VALID = 1;
			DATA_IN = 11;
			#10
			LINE_VALID = 1;
			DATA_IN = 12;
			#10
			LINE_VALID = 0;
			#10
			
			LINE_VALID = 1;
			DATA_IN = 21;
			#10
			LINE_VALID = 1;
			DATA_IN = 22;
			#10
			LINE_VALID = 0;
			#10
			
			LINE_VALID = 1;
			DATA_IN = 31;
			#10
			LINE_VALID = 1;
			DATA_IN = 32;
			#10
			LINE_VALID = 0;
			#30;
			#8;
			READ_ADDRESS = 1'b0;
			#10;
			READ_ADDRESS = 1'b1;
			#10;
			RESET_READY_FLAG = 1;
			READ_ADDRESS = 1'bX;
			#10;
			RESET_READY_FLAG = 0;
			#2;
			#30;
		end
	end
      
	always #5 PIXCLK <= ~PIXCLK;
  always #5 CLK <= ~CLK;
	
	initial #450 $finish;
	
endmodule

