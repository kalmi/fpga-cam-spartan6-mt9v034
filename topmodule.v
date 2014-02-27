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

wire [7:0] data_wire;
wire [7:0] data_in;
reg [7:0] r;
reg data_ready;

uart_receive uut1 (
	.RST(RST),
	.CLK(CLK1),
	.RXD(RXD),
	.REC_EN(RXD_EN),
	.DATA(data_in),
	.RXD_READY(DATA_RECEIVED_READY)
);

uart_send uut2 (
	.RST(RST), 
	.CLK(CLK1), 
	.TXD(TXD), 
	.UART_CLK(TXD_EN), 
	.DATA(data_wire), 
	.DATA_READY(data_ready), 
	.IDLE(SENDER_IDLE)
);


assign data_wire = r;

reg prev_SENDER_IDLE;
//reg prev_DATA_RECEIVED_READY = 0;
always@(posedge CLK1)
begin
	prev_SENDER_IDLE <= SENDER_IDLE & !RST;
/*
	prev_DATA_RECEIVED_READY <= DATA_RECEIVED_READY;
	 //its_sampling_time <= DATA_RECEIVED_READY && SENDER_IDLE;
	if(DATA_RECEIVED_READY && !prev_DATA_RECEIVED_READY)
	begin
		r <= data_in;
		data_ready <=1;
	end
	else
	begin
		data_ready <=0;
	end*/
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
