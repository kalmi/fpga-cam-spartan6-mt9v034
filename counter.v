`timescale 1ns / 1ps

module counter(
	input CLK,
	input RST,
	input EN,
	output [$clog2(MAX):0] VALUE,
	output MAXED
	);

	reg [$clog2(MAX):0] value;
	assign VALUE = value;

	parameter MAX = 0;
	
	assign MAXED = (value==MAX);
	
	always@(posedge CLK)
	begin
		if(RST|(MAXED&EN))
			value <= 0;
		else if(EN)
			value <= value+1;
	end

endmodule
