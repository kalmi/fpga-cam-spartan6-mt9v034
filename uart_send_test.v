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

	// Verification
	reg TXD_EXPECTED;
	wire TXD_DEVIATION = (TXD_EXPECTED !== TXD);
	reg first;

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
		CLK = 1;
		UART_CLK = 0;
		DATA = 8'bXXXXXXXX;
		DATA_READY = 0;
		
		//Initialize Verification
		TXD_EXPECTED=1;
		first = 1;
		error = 0;

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
		DATA = 8'b01001100;
		DATA_READY = 1;
		#20;
		DATA_READY = 0;
		#100;
		DATA = 8'bXXXXXXXX;
	end

	initial begin
		#100;
		TXD_EXPECTED <= 1; //STOP
		#50;
		TXD_EXPECTED <= 0; //START (of 10101010)
		#50;
		TXD_EXPECTED <= 0; //LSB
		#50;
		TXD_EXPECTED <= 1;
		#50;
		TXD_EXPECTED <= 0;
		#50;
		TXD_EXPECTED <= 1;
		#50;
		TXD_EXPECTED <= 0;
		#50;
		TXD_EXPECTED <= 1;
		#50;
		TXD_EXPECTED <= 0;
		#50;
		TXD_EXPECTED <= 1; //MSB
		#50;
		TXD_EXPECTED <= 1; //STOP
		#50;
		TXD_EXPECTED <= 0; //START (of 01001100)
		#50;
		TXD_EXPECTED <= 0; //LSB
		#50;
		TXD_EXPECTED <= 0;
		#50;
		TXD_EXPECTED <= 1;
		#50;
		TXD_EXPECTED <= 0;
		#50;
		TXD_EXPECTED <= 0;
		#50;
		TXD_EXPECTED <= 0;
		#50;
		TXD_EXPECTED <= 1;
		#50;
		TXD_EXPECTED <= 0; //MSB
		#50;
		TXD_EXPECTED <= 1; //STOP
	end
	
	reg error;
   always begin
      #1;
		if(TXD_DEVIATION&~error)
		begin
			$display("**** ERROR@%d ****", $time);
			$display("Not displaying further errors in this module");
			error=1;
		end
   end
	
	always #5 CLK <= ~CLK;
	
	always #45
	begin
		if(first)
		begin
			first<=0;
			#5;
		end
		
		UART_CLK <= 1;
		#5;
		UART_CLK <= 0;
   end;
	
endmodule
