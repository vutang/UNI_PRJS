module Stage_2_Reg
(
	input				clk, rst,
	input				ena,
	input		[3:0]	matching_tag_stage_2_in,
	output reg 	[3:0]	matching_tag_stage_2_out,

	input wire	[3:0]	matching_tag_bak_stage_2_in,
	output reg 	[3:0] 	matching_tag_bak_stage_2_out,

	// Forward Signal
	input wire	[11:0] 	incoming_tag_forward_in,
	output reg 	[11:0] 	incoming_tag_forward_out,

	input wire 	[3:0]	incoming_tag_for_bak_2_in,
	output reg 	[3:0] 	incoming_tag_for_bak_2_out
);
	
	always @(posedge clk)
		if (rst) begin
			matching_tag_stage_2_out <= 4'b0;
			matching_tag_bak_stage_2_out <= 4'b0;
			incoming_tag_forward_out <= 8'b0;
			incoming_tag_for_bak_2_out <= 4'b0;
		end
		else begin
			if (ena) begin
				matching_tag_stage_2_out <= matching_tag_stage_2_in;
				matching_tag_bak_stage_2_out <= matching_tag_bak_stage_2_in;
				incoming_tag_forward_out <= incoming_tag_forward_in;
				incoming_tag_for_bak_2_out <= incoming_tag_for_bak_2_in;
			end				
		end
	
endmodule