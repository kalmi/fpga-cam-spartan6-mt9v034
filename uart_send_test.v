`timescale 1ns / 1ps

module uart_send_test;

	// Inputs
	reg RST;
	reg CLK;
	reg [7:0] DATA;
	reg DATA_READY;

	// Outputs
	wire TXD;
	wire IDLE;
	
	// Instantiate the Unit Under Test (UUT)
	uart_send uut (
		.RST(RST), 
		.CLK(CLK),
		.DATA(DATA), 
		.DATA_READY(DATA_READY), 
		.TXD(TXD), 
		.IDLE(IDLE)
	);

	initial begin
		// Initialize Inputs
		RST = 1;
		CLK = 1;
		DATA = 8'bXXXXXXXX;
		DATA_READY = 0;

		// Wait some for reset to finish

		#18.52;
		#18.52;
	
		#18.52;
		#18.52;

		RST = 0;
		
		#18.52;
		#18.52;
		
		DATA = 8'b10101010;
		DATA_READY = 1;
		#1000;
		DATA_READY = 0;
		DATA = 8'bXXXXXXXX;
		#9000
		
		DATA = 8'b01001100;
		DATA_READY = 1;
		#1000;
		DATA_READY = 0;
		DATA = 8'bXXXXXXXX;
		#9000;
		
	end

	always #18.52 CLK <= ~CLK;	
	
endmodule
