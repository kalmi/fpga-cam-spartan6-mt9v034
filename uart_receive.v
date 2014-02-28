`timescale 1ns / 1ps

module uart_receive(
	input RST,
	input CLK,
	input RXD, //Serial data in
	output reg [7:0] DATA, // Input data 8 bit
	output reg RXD_READY // Data received
	);

wire [5:0] intra_bit_counter;
wire [4:0] state;
reg finished;

counter #(26) intra_bit_counter_(
		.CLK(CLK),
		.RST(RST|bit_rst),
		.MAXED(next_bit),
		.VALUE(intra_bit_counter),
		.EN(1'b1)
	);
	
counter #(10) state_counter(
		.CLK(CLK),
		.RST(RST|finished),
		.MAXED(state_maxed),
		.EN(next_bit|start),
		.VALUE(state) /* Values of STATE:
			0 (PRESTART)
			1 (START)
			2 (LSB)
			...
			9 (MSB)
			10 (STOP) */
	);

wire start_series = (last6==6'b111000);
assign bit_rst = (state==0) && !start_series;
assign start   = (state==0) &&  start_series;


reg [5:0] last6;
wire [2:0] last3 = last6[2:0];
wire majority_of_last3 = ((last3[0]&last3[1])|(last3[2]&last3[1])|(last3[2]&last3[0]));
reg [7:0] data;

always @(posedge CLK)
begin
	if(RST)
	begin
		RXD_READY <= 0;
	end
	
	if(1'b1)
	begin
		last6 <= {last6[4:0], RXD};
		
		if(state>=2 && state<=9 && intra_bit_counter==15)
		begin
			data[state-2] <= majority_of_last3;
			RXD_READY <= 0;
			//DATA <= 8'bXXXXXXXX;
		end
	end
	
	if(state_maxed)
	begin
		DATA <= data;
		RXD_READY <= 1;
	end
	
	finished <= state_maxed;
end

endmodule
