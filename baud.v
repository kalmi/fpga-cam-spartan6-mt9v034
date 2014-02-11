`timescale 1ns / 1ps

module baud(
    input CLK,
	 input RST,
    output RXD_EN,
	 output TXD_EN
    );

	assign RXD_EN = CLK;

	counter #(5'b11010) counter_txd_en(
		.CLK(CLK),
		.RST(RST),
		.MAXED(TXD_EN),
		.EN(1'b1)
	);

endmodule
