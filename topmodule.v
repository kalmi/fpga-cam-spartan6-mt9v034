`timescale 1ns / 1ps

module topmodule #(parameter H = 752, parameter V = 480) (
	input RST,
	input CLK,
	
	//DEBUG
	output [13:0] debug,
	
	//UART
	input UART_RXD,
	output UART_TXD,
	
	//CAMERA
	input CAM_PIXCLK,
	input CAM_FRAME_VALID,
	input CAM_LINE_VALID,
	input [9:0] CAM_DATA,
	output CAM_SYSCLK
	);

reg [$clog2(V)-1:0] selected_line = 0;
reg [$clog2(H)-1:0] selected_column = 0;

wire [9:0] CAPTURED_DATA;
wire [$clog2(V)-1:0] CAPTURED_CURRENT_LINE;
wire [$clog2(H)-1:0] CAPTURED_CURRENT_COLUMN;
wire CAPTURED_PIXEL_VALID;
assign CAM_SYSCLK = CLK;
camera #(H,V) camera (
	//inputs:
	.PIXCLK(CAM_PIXCLK), 
	.FRAME_VALID(CAM_FRAME_VALID),
	.LINE_VALID(CAM_LINE_VALID), 
	.DATA_IN(CAM_DATA), 
	//outputs:
	.DATA_OUT(CAPTURED_DATA), 
	.CURRENT_LINE(CAPTURED_CURRENT_LINE), 
	.CURRENT_COLUMN(CAPTURED_CURRENT_COLUMN), 
	.PIXEL_VALID(CAPTURED_PIXEL_VALID)
);

wire [7:0] SELECTED_PIXEL_DATA;
reg reset_buffer_ready_flag;
line_buffer #(H,V) line_buffer (
	//inputs:
	.CLK(CLK), 
	.VALID_DATA(CAPTURED_PIXEL_VALID), 
	.CURRENT_COLUMN(CAPTURED_CURRENT_COLUMN), 
	.CURRENT_LINE(CAPTURED_CURRENT_LINE), 
	.INTERESTING_LINE(selected_line), 
	.DATA_IN(CAPTURED_DATA[9:2]), 
	.READ_ADDRESS(selected_column), 
	.WHOLE_LINE_READY_FLAG(WHOLE_LINE_READY_FLAG), 
	//outputs:
	.RESET_READY_FLAG(reset_buffer_ready_flag), 
	.DATA_OUT(SELECTED_PIXEL_DATA)
);



reg [7:0] r;
reg uart_tx_data_ready = 0;

uart_send uart_send (
	.RST(RST), 
	.CLK(CLK), 
	.TXD(UART_TXD),
	.DATA(r), 
	.DATA_READY(uart_tx_data_ready), 
	.IDLE(uart_tx_idle)
);

(* keep="soft" *)
wire [7:0] unconnected_received_data;

uart_receive uart_receive (
	.RST(RST), 
	.CLK(CLK), 
	.RXD(UART_RXD),
	.DATA(unconnected_received_data), 
	.RXD_READY(rxd_ready)
);

reg prev_rxd_ready;
wire byte_just_received = rxd_ready&&!prev_rxd_ready;
always@(posedge CLK)
begin
	prev_rxd_ready <= rxd_ready;
end

reg sending_frame = 0;
always@(posedge CLK)
begin
	if(byte_just_received && !sending_frame)
	begin
		sending_frame <= 1;
		reset_buffer_ready_flag <= 0;
	end
	else
	if(WHOLE_LINE_READY_FLAG && uart_tx_idle && sending_frame)
	begin
		uart_tx_data_ready<=1;
		r<=SELECTED_PIXEL_DATA;
		
		if(selected_column+1 != H)
		begin
			selected_column <= selected_column+1'b1;
			reset_buffer_ready_flag <= 0;
		end
		else
		begin
			selected_column <= 0;
			if(selected_line+1 == V)
			begin
				sending_frame <= 0;
				selected_line <= 0;
				reset_buffer_ready_flag <= 0;
			end
			else
			begin
				selected_line <= selected_line+1'b1;
				reset_buffer_ready_flag <= 1;
			end
		end
	end
	else
	begin
		uart_tx_data_ready <= 0;
		reset_buffer_ready_flag <= !sending_frame;
	end
end

assign debug[0] = 1'b1;
assign debug[1] = sending_frame;
assign debug[2] = WHOLE_LINE_READY_FLAG;
assign debug[13:3] = 0;

endmodule
