`timescale 1ns / 1ps

module topmodule(
	input RST,
	input CLK,
	input RXD,
	output TXD
	);

reg [7:0] r;
reg data_ready;

uart_send uut2 (
	.RST(RST), 
	.CLK(CLK), 
	.TXD(TXD),
	.DATA(r), 
	.DATA_READY(data_ready), 
	.IDLE(SENDER_IDLE)
);

reg prev_SENDER_IDLE;
always@(posedge CLK)
begin
	prev_SENDER_IDLE <= SENDER_IDLE & !RST;

	if(RST)
	begin
		r <= "0";
		data_ready <= 0;
	end
	else if((SENDER_IDLE & !prev_SENDER_IDLE))
	begin
		data_ready <= 1;
		if(r < "9")
		begin
			r <= r + 1'b1;
		end
		else
		begin
			r <= "9";
		end
	end
	else
	begin
		data_ready <= 0;
	end
end
 
endmodule
