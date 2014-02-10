`timescale 1ns / 1ps

module uart_send(
  input RST,
  input CLK,
  input UART_CLK,	//Must not be 1 for longer than a single CLK
  input [7:0] DATA,
  input DATA_READY,	// Send enable (Samples the DATA input, and starts sending it.)
  output TXD, // Serial DATA out
  output IDLE // Ready to sample new data
  );

reg [3:0] counter; // State Machine: 0=PRESTART(still idle), 1=START, 2=LSB, ..., 9=MSB, 10=STOP
reg [7:0] data; // Sampled data
reg current_bit;

wire START_BIT = 1'b0;
wire STOP_BIT  = 1'b1;
wire framed_data[0:11] = {STOP_BIT, START_BIT, data_reversed, STOP_BIT, STOP_BIT}; //second stop bit is for overindexing
wire [7:0] data_reversed = {data[0], data[1], data[2], data[3], data[4], data[5], data[6], data[7]};
wire data_sampling = DATA_READY&IDLE;

assign TXD = current_bit|RST|IDLE; //High stands for idle
assign IDLE = (counter==10);

always @(posedge CLK)
begin
	if(RST)
		counter<=10;
	else if(data_sampling)
		counter<=0;
	else if(UART_CLK && counter!==10)
		counter<=counter+1;
	
  if(data_sampling)
    data<=DATA;

	current_bit <= framed_data[counter + UART_CLK]; //MPX to select current bit based on the counter state machine
end

endmodule