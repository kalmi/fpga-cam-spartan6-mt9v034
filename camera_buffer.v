`timescale 1ns / 1ps

module line_buffer #(parameter H = 752, parameter V = 480) ( 
	input CLK,
	input VALID_DATA,
	input [$clog2(V)-1:0] CURRENT_COLUMN,
	input [$clog2(H)-1:0] CURRENT_LINE,
	input [$clog2(H)-1:0] INTERESTING_LINE,
	input [7:0] DATA_IN,
	input [$clog2(V)-1:0] READ_ADDRESS,
	input RESET_READY_FLAG,
	output WHOLE_LINE_READY_FLAG,
	output reg [7:0] DATA_OUT);

reg [7:0] mem[2250:0];


localparam UNINTERESTED = 2'b00;
localparam RECORDING    = 2'b01;
localparam READY        = 2'b10;
localparam UNCLEAN      = 2'b11;

reg [1:0] prev_state = UNCLEAN;

reg [1:0] state;

always @ (*)
begin 
	case(prev_state)
		UNINTERESTED: state = (line_is_interesting ? RECORDING : UNINTERESTED);
		RECORDING:    state = (line_is_interesting ? RECORDING : READY); 
		READY:        state = (RESET_READY_FLAG    ? UNCLEAN   : READY);
		UNCLEAN:      state = (line_is_interesting ? UNCLEAN   : UNINTERESTED);
	endcase
end

always @ (posedge CLK)
begin
	prev_state <= state;
end

assign WHOLE_LINE_READY_FLAG = (state == READY);

wire line_is_interesting = (CURRENT_LINE==INTERESTING_LINE);


wire [$clog2(V)-1:0] read_address = READ_ADDRESS;
wire [$clog2(V)-1:0] write_address = CURRENT_COLUMN;

always @(posedge CLK) begin
	if(VALID_DATA && state == RECORDING)
	begin
		DATA_OUT <= mem[read_address];
		mem[write_address] <= DATA_IN;
	end
	else
		DATA_OUT <= mem[read_address];
end

endmodule
