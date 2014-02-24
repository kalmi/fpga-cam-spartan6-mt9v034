`timescale 1ns / 1ps

module topmodule(
    input RST,
	 input CLK,
	 input RXD,
    output TXD,
	 output [13:0] debug
    );

assign debug = 0;

reg its_sampling_time;

clk_wiz_v3_6 clk_m(CLK, CLK1, CLK2, CLK3);
baud baud(CLK1, RST, RXD_EN, TXD_EN);

wire [7:0] DATA_WIRE;

uart_receive uut1 (
	.RST(RST),
	.CLK(CLK1),
	.RXD(RXD),
	.REC_EN(RXD_EN),
	.DATA(DATA_WIRE),
	.RXD_READY(DATA_RECEIVED_READY)
);

uart_send uut2 (
	.RST(RST), 
	.CLK(CLK1), 
	.TXD(TXD), 
	.UART_CLK(TXD_EN), 
	.DATA(DATA_WIRE), 
	.DATA_READY(its_sampling_time), 
	.IDLE(SENDER_IDLE)
);

always@(posedge CLK1)
begin
	 its_sampling_time <= DATA_RECEIVED_READY && SENDER_IDLE;
end
 
endmodule
