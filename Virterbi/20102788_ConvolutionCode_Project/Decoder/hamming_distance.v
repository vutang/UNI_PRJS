module hamming_distance
#(parameter CODE_WIDTH = 2)
(
	input [CODE_WIDTH-1:0] in1, in2,
	output [CODE_WIDTH-1:0] hd
);

wire [CODE_WIDTH-1:0] in_xor;
//reg [CODE_WIDTH-1:0] cnt1, cnt2;
assign in_xor = in1 ^ in2;
assign hd = (in_xor == 2'b00)? 0 : (in_xor == 2'b11)? 2 :1;
endmodule