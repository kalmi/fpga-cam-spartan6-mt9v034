`timescale 1ns / 1ps

module topmodule(
	input RST,
	input CLK,
	input RXD,
	output TXD
	);

reg [7:0] r;
wire [7:0] received_data;
reg pending_send = 0;

uart_send uut2 (
	.RST(RST), 
	.CLK(CLK), 
	.TXD(TXD),
	.DATA(r), 
	.DATA_READY(pending_send), 
	.IDLE(sender_idle)
);

uart_receive uut3 (
	.RST(RST), 
	.CLK(CLK), 
	.RXD(RXD),
	.DATA(received_data), 
	.RXD_READY(rxd_ready)
);

reg prev_rxd_ready;

always@(posedge CLK)
begin
	prev_rxd_ready <= rxd_ready;
	
	if(rxd_ready&&!prev_rxd_ready)
	begin
		pending_send<=1;
		r<=received_data;
	end
	else
		pending_send<=0;
end
 
endmodule
