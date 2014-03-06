`timescale 1ns / 1ps

module counter #(parameter MAX = 1'bX) (
	input CLK,
	input RST,
	input EN,
	output [$clog2(MAX)-1:0] VALUE,
	output MAXED
	);

	reg [$clog2(MAX)-1:0] value;
	assign VALUE = value;
	
	assign MAXED = (value==MAX);
	
	always@(posedge CLK)
	begin
		if(RST|(MAXED&EN))
			value <= 0;
		else if(EN)
			value <= value + 1'b1;
	end

endmodule
