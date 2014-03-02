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
reg [7:0] data; // Sampled data

localparam START_BIT = 1'b0;
localparam STOP_BIT  = 1'b1;
wire framed_data[0:10] = {STOP_BIT, START_BIT, data_reversed, STOP_BIT};
wire [7:0] data_reversed = {data[0], data[1], data[2], data[3], data[4], data[5], data[6], data[7]};
wire data_sampling = DATA_READY&IDLE; 

wire current_bit = framed_data[counter];

assign TXD = current_bit;
assign IDLE = (counter+next_bit >= 10);

always @(posedge CLK)
begin
	if(RST)
		counter<=10;
	else if(data_sampling)
		counter<=0;
	else if(next_bit && counter!==10)
		counter<=(counter + 1'b1);
	
  if(data_sampling)
    data<=DATA;
end

endmodule