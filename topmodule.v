`timescale 1ns / 1ps

module topmodule(
    input RST,
	 input CLK,
	 input RXD,
    output TXD,
	 output [13:0] debug
    );

assign debug = 0;

reg [7:0] r;
reg data_ready;

counter #(5'b11010) counter_txd_en(
	.CLK(CLK),
	.RST(RST),
	.MAXED(TXD_EN),
	.EN(1'b1)
);

uart_send uut2 (
	.RST(RST), 
	.CLK(CLK), 
	.TXD(TXD), 
	.UART_CLK(TXD_EN), 
	.DATA(r), 
	.DATA_READY(data_ready), 
	.IDLE(SENDER_IDLE)
);


assign data_wire = r;

reg preamble;

reg prev_SENDER_IDLE;
always@(posedge CLK)
begin
	prev_SENDER_IDLE <= SENDER_IDLE & !RST;

	if(RST)
	begin
		r <= 48;
		data_ready <= 0;
	end
	else if((SENDER_IDLE & !prev_SENDER_IDLE))
	begin
		data_ready <= 1;
		if(r < 57)
		begin
			r <= r + 1;
		end
		else
		begin
			r <= 48;
		end
	end
	else
	begin
		data_ready <= 0;
	end
end
 
endmodule
