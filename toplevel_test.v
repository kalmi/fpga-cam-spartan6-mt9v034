`timescale 1ns / 1ps

module toplevel_test;

	// Inputs
	// UART
	reg RST = 1;
	reg CLK = 0;
	reg RXD = 1;
	//CAMERA
	reg PIXCLK = 1;
	reg FRAME_VALID = 0;
	reg LINE_VALID = 0;
	reg [9:0] DATA_IN = 0;

	// Outputs
	wire TXD;
	wire CAM_SYSCLK = CLK;

	// Instantiate the Unit Under Test (UUT)
	topmodule #(3,2) uut (
		.RST(RST), 
		.CLK(CLK), 
		.UART_RXD(RXD), 
		.UART_TXD(TXD),
		.CAM_PIXCLK(PIXCLK),
		.CAM_FRAME_VALID(FRAME_VALID),
		.CAM_LINE_VALID(LINE_VALID),
		.CAM_DATA(DATA_IN)
	);

	wire [7:0] DECODED;
	wire DECODED_READY;

	uart_receive uut1 (
		.RST(RST),
		.CLK(CLK),
		.RXD(TXD),
		.DATA(DECODED),
		.RXD_READY(DECODED_READY)
	);


	initial begin
	
		// Wait for global reset to finish
		#1000;
		RST = 0;
		#3000;
		
		//...STOP, START, 1, 0, 1, 0, 1, 0, 1, 0, STOP... 
		RXD = 0;
		#1000;
		RXD = 0;
		#1000;
		RXD = 1;
		#1000;
		RXD = 0;
		#1000;
		RXD = 1;
		#1000;
		RXD = 0;
		#1000;
		RXD = 1;
		#1000;
		RXD = 0;
		#1000;
		RXD = 1;
		#1000;
		RXD = 1;
		#1000;
		
	end
	
	initial begin
		// Initialize Inputs
		LINE_VALID = 1;
		FRAME_VALID = 1;
		DATA_IN = 0;
		// Test ignoring of random already ongoing frame
		#1852;
		#1852;
		#1852;
		forever
		begin
			LINE_VALID = 0;
			FRAME_VALID = 0;
			#37.04;
			
			FRAME_VALID = 1;
			#37.04;
			
			LINE_VALID = 1;
			DATA_IN = 11<<2;
			#37.04;
			LINE_VALID = 1;
			DATA_IN = 12<<2;
			#37.04;
			LINE_VALID = 0;
			#37.04;
			
			LINE_VALID = 1;
			DATA_IN = 21<<2;
			#37.04;
			LINE_VALID = 1;
			DATA_IN = 22<<2;
			#37.04;
			LINE_VALID = 0;
			#37.04;
			
			LINE_VALID = 1;
			DATA_IN = 31<<2;
			#37.04;
			LINE_VALID = 1;
			DATA_IN = 32<<2;
			#37.04;
		end
	end
	
always #18.52 CLK <= ~CLK;
always #18.52 PIXCLK <= ~PIXCLK;
	
initial #100000 $finish;      
	
endmodule

