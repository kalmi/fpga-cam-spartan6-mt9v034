`timescale 1ns / 1ps

module uart_send(
    input RST, //Reset
	 input CLK,	//27MHz clock
	 input UART_CLK,	// Divided clock: 1 MHz
	 input [7:0] DATA, // Output DATA 8 bit
	 input DATA_READY,	// Send enable
    output TXD, //serial DATA out
	 output IDLE
    );

reg [3:0] counter; // State Machine: 0=PRESTART(still idle), 1=START, 2=LSB, ..., 9=MSB, 10=STOP
reg [7:0] data;
reg current_bit;

wire [7:0] data_reversed = {data[0], data[1], data[2], data[3], data[4], data[5], data[6], data[7]};

wire START_BIT = 1'b0;
wire STOP_BIT  = 1'b1;
wire framed_data[0:11] = {STOP_BIT, START_BIT, data_reversed, STOP_BIT, STOP_BIT}; //second stop bit is for overindexing
assign TXD = current_bit|RST|IDLE; //High stands for idle
assign IDLE = (counter==10);

always @(posedge CLK)
begin
	if(RST)
	begin
		counter<=10;
	end
	else if(DATA_READY&IDLE)
	begin
		data<=DATA;
		counter<=0;
	end
	else if(UART_CLK && counter!==10)
	begin
		counter<=counter+1;
	end
end

//MPX to select current bit based on the counter state machine
always @(posedge CLK)
begin
	current_bit <= framed_data[counter + UART_CLK];
end

endmodule