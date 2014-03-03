`timescale 1ns / 1ps

module topmodule(
	input RST,
	input CLK,
	input RXD,
	output TXD
	);

reg [7:0] r;
reg data_ready;

uart_send uut2 (
	.RST(RST), 
	.CLK(CLK), 
	.TXD(TXD),
	.DATA(r), 
	.DATA_READY(data_ready), 
	.IDLE(sender_idle)
);

uart_receive uut3 (
	.RST(RST), 
	.CLK(CLK), 
	.RXD(RXD),
	.DATA(), 
	.RXD_READY(rxd_ready)
);

reg start;

reg prev_rxd_ready;

always@(posedge CLK)
begin
	prev_rxd_ready <= rxd_ready;
	if(RST)
		start <= 0;
	else if(rxd_ready&&!prev_rxd_ready)
		start <= !start;
	else
		start <= start&&(r <= "9");
end

always@(posedge CLK)
begin
	if(RST)
	begin
		r <= "0"-1;
		data_ready <= 0;
	end
	else
	if(start)
	begin
		if(sender_idle)
		begin
			data_ready <= (r>="0"-1) && start;
			if(r < "9")
			begin
				r <= r + 1'b1;
			end
			else
				r <= "0";
		end
		else
		begin
			data_ready <= 0;
		end
	end
	else
		data_ready <= 0;
end
 
endmodule
