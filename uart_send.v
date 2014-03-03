`timescale 1ns / 1ps

module uart_send(
	input RST,
	input CLK,
	input [7:0] DATA,
	input DATA_READY,	// Send enable (Samples the DATA input, and starts sending it.)
	output TXD, // Serial DATA out
	output IDLE // Ready to sample new data
	);

	counter #(5'b11010) counter_txd_en(
		.CLK(CLK),
		.RST(RST),
		.MAXED(next_bit),
		.EN(1'b1),
		.VALUE()
	);

reg [3:0] counter; // State Machine: 0=PRESTART(still idle), 1=START, 2=LSB, ..., 9=MSB, 10=STOP
reg [0:10] shr; // Sampled framed_data (that gets shifted when "next_bit")

localparam START_BIT = 1'b0;
localparam STOP_BIT  = 1'b1;
wire [0:10] framed_data = {STOP_BIT, START_BIT, data_reversed, STOP_BIT};
wire [7:0] data_reversed = {DATA[0], DATA[1], DATA[2], DATA[3], DATA[4], DATA[5], DATA[6], DATA[7]};

wire data_sampling = DATA_READY&IDLE;

wire current_bit = shr[0];
assign TXD = current_bit;
assign IDLE = (counter+next_bit >= 10);

always @(posedge CLK)
begin
	if(RST)
	begin
		shr[0] <= 1'b1;
		counter<=10;
	end
	else if(data_sampling)
	begin
		counter<=0;
		shr <= framed_data;
	end
	else if(next_bit && counter!==10)
	begin
		counter<=(counter + 1'b1);
		shr <= (shr<<1);
	end
end

endmodule