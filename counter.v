`timescale 1ns / 1ps

module counter(
	input CLK,
	input RST,
	input EN,
	output reg [$clog2(MAX):0] VALUE,
	output MAXED
	);

	parameter MAX = 0;
	
	assign MAXED = (VALUE==MAX);
	
	always@(posedge CLK)
	begin
		if(RST|(MAXED&EN))
			VALUE <= 0;
		else if(EN)
			VALUE <= VALUE+1;
	end

endmodule
