module Input_Reg
(
	input wire			clk, rst, 
	input wire 			ena,
	output reg 			ena_foward,
	input wire	[11:0]	incoming_tag_in,
	output reg 	[11:0]	incoming_tag_out
);

	always @(posedge clk)
		if(rst) begin
			incoming_tag_out <= 12'b0;
			ena_foward <= 0;
		end
		else begin 
			if (ena) begin
				incoming_tag_out <= incoming_tag_in;
			end
			else begin
				incoming_tag_out <= incoming_tag_out;
			end
			ena_foward <= ena;
		end

endmodule