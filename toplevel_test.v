`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:23:15 02/27/2014
// Design Name:   topmodule
// Module Name:   C:/Users/kalmi/Dropbox/Suli/onlab/repo/toplevel_test.v
// Project Name:  fpga_cam
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: topmodule
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

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

