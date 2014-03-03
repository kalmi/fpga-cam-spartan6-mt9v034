`timescale 1ns / 1ps

module uart_receive_test;

	// Inputs
	reg RST;
	reg CLK;
	reg RXD;

	// Outputs
	wire [7:0] DATA;
	wire RXD_READY;

	// Instantiate the Unit Under Test (UUT)
	uart_receive uut (
		.RST(RST), 
		.CLK(CLK), 
		.RXD(RXD),
		.DATA(DATA), 
		.RXD_READY(RXD_READY)
	);

	initial begin
		// Initialize Inputs
		RST = 1;
		CLK = 1;
		RXD = 1;

		// Wait 100 ns for global reset to finish
		#100;
		RST = 0;
		#5000;
		
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
		
		//...STOP, START, 0, 1, 0, 1, 0, 1, 0, 1, STOP... 
		#5000;
		RXD = 0;
		#1000;
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

	end

	always #18.52 CLK <= ~CLK;
	
endmodule

