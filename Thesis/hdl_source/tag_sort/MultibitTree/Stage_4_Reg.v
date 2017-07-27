module Stage_4_Reg
(
	input wire			clk, rst,
	input wire 			ena, 

	input wire 	[3:0]	matching_tag_stage_4_in,
	output reg 	[3:0]	matching_tag_stage_4_out,

	input wire	[3:0] 	matching_tag_bak_1_stage_4_in,
	output reg 	[3:0]	matching_tag_bak_1_stage_4_out,

	input wire	[3:0] 	matching_tag_bak_2_stage_4_in,
	output reg 	[3:0]	matching_tag_bak_2_stage_4_out,

	input wire 			not_found_signal_in,
	output reg 			not_found_signal_out,

	// forward signal
	input wire	[11:0]	incoming_tag_forward_in,
	output reg 	[11:0]	incoming_tag_forward_out,

	input wire	[3:0] 	matching_tag_forward_in,
	output reg 	[3:0] 	matching_tag_forward_out,

	input wire 	[3:0] 	matching_tag_1_bak_in,
	output reg 	[3:0]	matching_tag_1_bak_out
);
	
	always @(posedge clk)
		if (rst) begin
			matching_tag_stage_4_out <= 4'b0;
			matching_tag_bak_1_stage_4_out <= 4'b0;
			matching_tag_bak_2_stage_4_out <= 4'b0;
			not_found_signal_out <= 1'b0;
			incoming_tag_forward_out <= 4'b0;
			matching_tag_forward_out <= 4'b0;
			matching_tag_1_bak_out <= 4'b0;
		end
		else begin
			if (ena) begin
				matching_tag_stage_4_out <= matching_tag_stage_4_in;
				matching_tag_bak_1_stage_4_out <= matching_tag_bak_1_stage_4_in;
				matching_tag_bak_2_stage_4_out <= matching_tag_bak_2_stage_4_in;
				not_found_signal_out <= not_found_signal_in;
				incoming_tag_forward_out <= incoming_tag_forward_in;
				matching_tag_forward_out <= matching_tag_forward_in;
				matching_tag_1_bak_out <= matching_tag_1_bak_in;
			end	
		end

endmodule