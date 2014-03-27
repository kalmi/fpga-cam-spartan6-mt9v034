`timescale 1ns / 1ps

module camera #(parameter H = 752, parameter V = 480) (
	input PIXCLK, //"The PIXCLK is a nominally inverted version of the master clock (SYSCLK)."
	input LINE_VALID,
	input FRAME_VALID,
	input [9:0] DATA_IN,
	output [9:0] DATA_OUT,
	output [$clog2(V)-1:0] CURRENT_LINE,
	output [$clog2(H)-1:0] CURRENT_COLUMN,
	output PIXEL_VALID
);


assign DATA_OUT = data;
reg[9:0] data;

always @ (posedge PIXCLK)
begin
	data<=DATA_IN;
end


reg prev_frame_valid = 1; // so that we don't mistake "0->1" for a valid frame start
always @ (posedge PIXCLK)
begin
	prev_frame_valid <= FRAME_VALID;
end

reg frame_start_seen = 0;
wire frame_start_seen_now = (FRAME_VALID && !prev_frame_valid) || frame_start_seen;
always @ (posedge PIXCLK)
begin
	frame_start_seen <= frame_start_seen_now;
end

reg pixel_valid = 0;
assign PIXEL_VALID = pixel_valid;
always @ (posedge PIXCLK)
begin
	pixel_valid <= (frame_start_seen_now && LINE_VALID && FRAME_VALID);
end


reg prev_line_valid = 0;
always @ (posedge PIXCLK)
begin
	prev_line_valid <= LINE_VALID;
end

wire line_ended = (prev_line_valid && !LINE_VALID);

counter #(V) current_line_counter(
	.CLK(PIXCLK),
	.RST(!FRAME_VALID||!frame_start_seen),
	.MAXED(),
	.EN(line_ended),
	.VALUE(CURRENT_LINE)
);

counter #(H) current_column_counter(
	.CLK(PIXCLK),
	.RST(!LINE_VALID||!frame_start_seen),
	.MAXED(),
	.EN(prev_line_valid),
	.VALUE(CURRENT_COLUMN)
);

endmodule
