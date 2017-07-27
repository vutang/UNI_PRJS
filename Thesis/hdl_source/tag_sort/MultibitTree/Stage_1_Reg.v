module Stage_1_Reg
(
	input wire 			clk, rst,
	input wire 			ena,

	input wire	[11:0]	incoming_tag_forward_in,
	output reg	[11:0]	incoming_tag_forward_out,

	input wire 	[3:0] 	incoming_tag_for_bak_1_in,
	output reg 	[3:0] 	incoming_tag_for_bak_1_out,

	input wire 	[3:0] 	incoming_tag_for_bak_2_in,
	output reg 	[3:0] 	incoming_tag_for_bak_2_out
);
	
	always @(posedge clk)
	if (rst) begin
		incoming_tag_forward_out <= 4'b0;
		incoming_tag_for_bak_1_out <= 4'b0;
		incoming_tag_for_bak_2_out <= 4'b0;
	end
	else begin
		if (ena) begin
			incoming_tag_forward_out <= incoming_tag_forward_in;
			incoming_tag_for_bak_1_out <= incoming_tag_for_bak_1_in;
			incoming_tag_for_bak_2_out <= incoming_tag_for_bak_2_in;
		end			
	end

endmodule 