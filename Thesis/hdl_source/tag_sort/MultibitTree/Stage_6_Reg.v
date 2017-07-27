module Stage_6_Reg
(
	input wire			clk, rst,
	input wire			ena,
	input wire	[11:0]	matching_tag_forward_in,
	output reg 	[11:0]	matching_tag_forward_out,

	// forward signals
	input wire 	[11:0] 	incoming_tag_forward_in,
	output reg 	[11:0] 	incoming_tag_forward_out
);
	
	always @(posedge clk)
		if (rst) begin
			matching_tag_forward_out <= 12'b0;
			incoming_tag_forward_out  <= 12'b0;
		end
		else begin
			if (ena) begin
				matching_tag_forward_out <= matching_tag_forward_in;
				incoming_tag_forward_out <= incoming_tag_forward_in;
			end
		end
	
endmodule