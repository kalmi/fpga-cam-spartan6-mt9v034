`timescale 1ns / 1ps
`define __window__coord(column,line) ((line*WINDOW_SIZE+column)*8)
`define __window__WINDOW_reg_size ($clog2(WINDOW_SIZE*WINDOW_SIZE*8)-1)

module window #(parameter H = 752, parameter V = 480, parameter WINDOW_SIZE = 6) ( 
	input CLK,
	input VALID_DATA,
	input VALID_FRAME, //needed(?) so that we can return to sane state in case of noise
	input [$clog2(H)-1:0] CURRENT_COLUMN,
	input [$clog2(V)-1:0] CURRENT_LINE,
	input [7:0] DATA_IN,
	output reg [$clog2(WINDOW_SIZE*WINDOW_SIZE*8)-1:0] WINDOW,
	output reg VALID_WINDOW,
	output reg [$clog2(H)-1:0] BR_COLUMN, //Bottom right (in window)
	output reg [$clog2(V)-1:0] BR_LINE    //Bottom right (in window)
);

always@(posedge CLK)
begin
	VALID_WINDOW <= VALID_DATA;
	BR_COLUMN <= CURRENT_COLUMN;
	BR_LINE <= CURRENT_LINE;
end

wire [$clog2(WINDOW_SIZE):0] line_ready;
reg [$clog2(V)-1:0] top_line = 0;
reg reset_line_ready_flag = 0;

always@(posedge CLK)
begin
	if(!VALID_FRAME)
	begin
		top_line <= 0;
		reset_line_ready_flag <= 1;
	end
	
	if(VALID_FRAME)
	begin
		if(|line_ready)
		begin
			reset_line_ready_flag <= 1;
			top_line <= top_line + 1;
		end
		else
		begin
			reset_line_ready_flag <= 0;
		end
	end
end

wire [7:0] currently_selected_pixel_for_line[WINDOW_SIZE-1:0];

genvar line;
generate

	for (line = 0; line < WINDOW_SIZE; line = line + 1)
	begin: row_gen
	
		line_buffer #(H,V) line_buffer (
			//inputs:
			.CLK(CLK), 
			.VALID_DATA(VALID_DATA), 
			.CURRENT_COLUMN(CURRENT_COLUMN), 
			.CURRENT_LINE(CURRENT_LINE), 
			.INTERESTING_LINE(((top_line+line)%V)%WINDOW_SIZE), 
			.DATA_IN(DATA_IN), 
			.READ_ADDRESS(CURRENT_COLUMN), 
			.RESET_READY_FLAG(reset_line_ready_flag), 
			//outputs:
			.WHOLE_LINE_READY_FLAG(line_ready[line]), 
			.DATA_OUT(currently_selected_pixel_for_line[column])
		);
		
		always@(posedge CLK)
		begin
			 WINDOW[__window__coord(column,line)+:8] <= currently_selected_pixel_for_line[column];
		end
		
		genvar line;
		for (line = 0; line < WINDOW_SIZE-1; line = line + 1)
		begin: row_gen
			always@(posedge CLK)
			begin
				WINDOW[__window__coord(column,line)+:8] <= WINDOW[__window__coord(column,line+1)+:8];
			end
		end
		
	end
endgenerate

endmodule
