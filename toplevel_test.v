`timescale 1ns / 1ps

module toplevel_test;

	// Inputs
	reg RST;
	reg CLK;
	reg RXD;

	// Outputs
	wire TXD;
	wire [13:0] debug;

	// Instantiate the Unit Under Test (UUT)
	topmodule uut (
		.RST(RST), 
		.CLK(CLK), 
		.RXD(RXD), 
		.TXD(TXD), 
		.debug(debug)
	);

	initial begin
		// Initialize Inputs
		RST = 1;
		CLK = 0;
		RXD  = 1;

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

		#15000;
		
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
      
always #18.52 CLK <= ~CLK;

endmodule

