module Stage_3_Reg
(
	input 					clk, rst,
	input wire 				ena,

	input wire 	[3:0]		matching_tag_forward_in,
	output reg 	[3:0]		matching_tag_forward_out,

	input wire	[3:0] 		matching_tag_bak_forward_in,
	output reg 	[3:0] 		matching_tag_bak_forward_out,

	input wire 	[11:0] 		incoming_tag_forward_in,
	output reg 	[11:0]		incoming_tag_forward_out,

	input wire 	[3:0]		incoming_tag_for_bak_2_in,
	output reg 	[3:0] 		incoming_tag_for_bak_2_out,

	input wire	[15:0]		mask_mem_2_in,
	output reg 	[15:0] 		mask_mem_2_out
);
	always @(posedge clk)
	if (rst) begin
		matching_tag_forward_out <= 4'b0;
		matching_tag_bak_forward_out <= 4'b0;
		incoming_tag_forward_out <= 8'b0;
		incoming_tag_for_bak_2_out <= 4'b0;
		mask_mem_2_out <= 0;
	end
	else begin
		if (ena) begin
			matching_tag_forward_out <= matching_tag_forward_in;
			matching_tag_bak_forward_out <= matching_tag_bak_forward_in;
			incoming_tag_forward_out <= incoming_tag_forward_in;
			incoming_tag_for_bak_2_out <= incoming_tag_for_bak_2_in;
			mask_mem_2_out <= mask_mem_2_in;
		end			
	end

endmodule 