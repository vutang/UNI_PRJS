module Stage_5_Reg
(
	input			clk, rst,
	input 			ena,

	// forward signal
	input wire	[11:0]	incoming_tag_forward_in,
	output reg	[11:0]	incoming_tag_forward_out,

	input wire 	[7:0]	matching_tag_forward_in,
	output reg	[7:0] 	matching_tag_forward_out,

	input wire 	[7:0]	matching_tag_bak_forward_in,
	output reg 	[7:0] 	matching_tag_bak_forward_out
);

	always @(posedge clk)
		if (rst) begin
			incoming_tag_forward_out <= 4'b0;
			matching_tag_forward_out <= 8'b0;
			matching_tag_bak_forward_out <= 4'b0;
		end
		else begin
			if (ena) begin
				incoming_tag_forward_out <= incoming_tag_forward_in;
				matching_tag_forward_out <= matching_tag_forward_in;
				matching_tag_bak_forward_out <= matching_tag_bak_forward_in;
			end
		end

endmodule
