`timescale 1ns / 1ps

module uart_send_test;

	// Inputs
	reg RST;
	reg CLK;
	reg UART_CLK;
	reg [7:0] DATA;
	reg DATA_READY;

	// Outputs
	wire TXD;
	wire IDLE;

	// Instantiate the Unit Under Test (UUT)
	uart_send uut (
		.RST(RST), 
		.CLK(CLK), 
		.UART_CLK(UART_CLK), 
		.DATA(DATA), 
		.DATA_READY(DATA_READY), 
		.TXD(TXD), 
		.IDLE(IDLE)
	);

	initial begin
		// Initialize Inputs
		RST = 1;
		CLK = 0;
		UART_CLK = 0;
		DATA = 8'bXXXXXXXX;
		DATA_READY = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		RST = 0;
		#20;
		//DATA=0;
		DATA = 8'b10101010;
		DATA_READY = 1;
		#20;
		DATA_READY = 0;
		#100
		DATA = 8'bXXXXXXXX;
		
		#360;
		DATA = 8'b1001100;
		DATA_READY = 1;
		#20;
		DATA_READY = 0;
		#100;
		DATA = 8'bXXXXXXXX;
	end

	always #5 CLK <= ~CLK;
	
	always #45
	begin
		UART_CLK <= 1;
		#5;
		UART_CLK <= 0;
   end;
	
endmodule

