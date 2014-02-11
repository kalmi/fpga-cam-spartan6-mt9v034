`timescale 1ns / 1ps

module uart_receive_test;

	// Inputs
	reg RST;
	reg CLK;
	reg RXD;
	reg REC_EN;

	// Outputs
	wire [7:0] DATA;
	wire RXD_READY;

	// Instantiate the Unit Under Test (UUT)
	uart_receive uut (
		.RST(RST), 
		.CLK(CLK), 
		.RXD(RXD), 
		.REC_EN(REC_EN), 
		.DATA(DATA), 
		.RXD_READY(RXD_READY)
	);

	initial begin
		// Initialize Inputs
		RST = 1;
		CLK = 1;
		RXD = 1;
		REC_EN = 0;
		first=1;

		// Wait 100 ns for global reset to finish
		#100;
		RST = 0;
		#1350;
		
		//...STOP, START, 1, 0, 1, 0, 1, 0, 1, 0, STOP... 
		RXD = 0;
		#1350;
		RXD = 0;
		#1350;
		RXD = 1;
		#1350;
		RXD = 0;
		#1350;
		RXD = 1;
		#1350;
		RXD = 0;
		#1350;
		RXD = 1;
		#1350;
		RXD = 0;
		#1350;
		RXD = 1;
		#1350;
		RXD = 1;
		#1350;
		
		//...STOP, START, 0, 1, 0, 1, 0, 1, 0, 1, STOP... 
		#5000;
		RXD = 0;
		#1350;
		RXD = 0;
		#1350;
		RXD = 0;
		#1350;
		RXD = 1;
		#1350;
		RXD = 0;
		#1350;
		RXD = 1;
		#1350;
		RXD = 0;
		#1350;
		RXD = 1;
		#1350;
		RXD = 0;
		#1350;
		RXD = 1;
		#1350;

	end
	
	
	
      
	always #5 CLK <= ~CLK;
	
	reg first;
	always #45
	begin
		if(first)
		begin
			first<=0;
			#5;
		end
		
		REC_EN <= 1;
		#5;
		REC_EN <= 0;
   end;
	
endmodule

