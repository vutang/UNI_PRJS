module ViterbiDecoder_top
(
	input clk, rst,
	input [1:0] code_in,
	output [9:0] code_out,
	output done
);

ViterbiDecoder mod(.rst(rst), .clk(clk), .code_in(code_in), .st(1'b1), .data_out(code_out), .done(done));

endmodule