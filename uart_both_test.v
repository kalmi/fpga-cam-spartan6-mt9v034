`timescale 1ns / 1ps

module uart_both_test;

	reg RST;
	reg CLK;
	
	reg [7:0] i;
	
	wire LINE;
	
	wire SENDER_IDLE; 

	wire [7:0] DATA_RECEIVED;
	reg  [7:0] DATA_TO_BE_SENT;
	reg        DATA_TO_BE_SENT_READY;

	uart_receive uut1 (
		.RST(RST),
		.CLK(CLK),
		.RXD(LINE),
		.DATA(DATA_RECEIVED),
		.RXD_READY(DATA_RECEIVED_READY)
	);
	
	uart_send uut2 (
		.RST(RST), 
		.CLK(CLK),
		.DATA(DATA_TO_BE_SENT), 
		.DATA_READY(DATA_TO_BE_SENT_READY), 
		.TXD(LINE), 
		.IDLE(SENDER_IDLE)
	);

	initial begin
		// Initialize Inputs
		RST = 1;
		CLK = 0;
		i = 0;
		DATA_TO_BE_SENT_READY = 0;

		// Wait for global reset to finish
		#926;
		RST = 0;
		#18.52;
		#18.52;
		DATA_TO_BE_SENT = 8'b00000000;
      DATA_TO_BE_SENT_READY = 1;
		#18.52;
		#18.52;
		DATA_TO_BE_SENT_READY = 0;
		
		while(1)
		begin
			while(~SENDER_IDLE)
			begin
				#1;
			end
			
			i=i+1;
			DATA_TO_BE_SENT = i;
			DATA_TO_BE_SENT_READY = 1;
			#1852;
			DATA_TO_BE_SENT_READY = 0;
			DATA_TO_BE_SENT = 8'bXXXXXXXX;
			#18.52;
			#18.52;
		end
		
	end
	
	always #18.52 CLK <= ~CLK;
	
endmodule
