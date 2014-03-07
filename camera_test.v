`timescale 1ns / 1ps

module camera_test;

	// Inputs
	reg PIXCLK;
	reg LINE_VALID;
	reg FRAME_VALID;
	reg [9:0] DATA_IN;

	// Outputs
	wire [9:0] DATA_OUT;
	wire [1:0] CURRENT_LINE;
	wire [0:0] CURRENT_COLUMN;
	wire PIXEL_VALID;

	// Instantiate the Unit Under Test (UUT)
	camera #(3,2) uut (
		.PIXCLK(PIXCLK), 
		.LINE_VALID(LINE_VALID), 
		.FRAME_VALID(FRAME_VALID), 
		.DATA_IN(DATA_IN), 
		.DATA_OUT(DATA_OUT), 
		.CURRENT_LINE(CURRENT_LINE), 
		.CURRENT_COLUMN(CURRENT_COLUMN), 
		.PIXEL_VALID(PIXEL_VALID)
	);

	initial begin
		// Initialize Inputs
		PIXCLK = 0;
		LINE_VALID = 1;
		FRAME_VALID = 1;
		DATA_IN = 0;
		// Test ignoring of random already ongoing frame
		#42;
		LINE_VALID = 0;
		FRAME_VALID = 0;
		#20;
		
		FRAME_VALID = 1;
		
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
		#10
		
		FRAME_VALID = 0;

	end
      
	always #5 PIXCLK <= ~PIXCLK;
endmodule

