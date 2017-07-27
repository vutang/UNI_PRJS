module Multibit_Tree_Top
#(
	parameter T = 12
)
(
	input wire 			clk, rst,
	input wire			ena,
	input wire 	[T-1:0] incoming_tag,
	output wire [T-1:0] matching_tag,
	output wire	[T-1:0]	incoming_tag_forward
);
	
	reg [4:0] 	counter;
	always @(posedge clk) begin
		if (rst) begin
			counter <= 0;
		end
		else if (counter < 16) begin
			counter <= counter + 1;
		end
		else begin
			counter <= 0;
		end
	end

	Multibit_Tree 
		#(.T(T))
		Multibit_Tree
		(
			.clk 					(clk),
			.rst 					(rst),
			.ena 					(ena),
			.incoming_tag 			(incoming_tag),
			.matching_tag 			(matching_tag),
			.incoming_tag_forward	(incoming_tag_forward)
		);

endmodule