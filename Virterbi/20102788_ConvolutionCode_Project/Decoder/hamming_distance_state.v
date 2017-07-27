module hamming_distance_state
#(parameter CODE_WIDTH = 2)
(
	input clk, rst, st,
	input [1:0] data_in,
	output [3:0] node0, node1, node2, node3,
	output done
);
hamming_distance #(2) m11(.in1(data_in), .in2(2'b00), .hd(node0[1:0]));
hamming_distance #(2) m12(.in1(data_in), .in2(2'b11), .hd(node0[3:2]));
hamming_distance #(2) m21(.in1(data_in), .in2(2'b10), .hd(node1[1:0]));
hamming_distance #(2) m22(.in1(data_in), .in2(2'b01), .hd(node1[3:2]));
hamming_distance #(2) m31(.in1(data_in), .in2(2'b11), .hd(node2[1:0]));
hamming_distance #(2) m32(.in1(data_in), .in2(2'b00), .hd(node2[3:2]));
hamming_distance #(2) m41(.in1(data_in), .in2(2'b01), .hd(node3[1:0]));
hamming_distance #(2) m42(.in1(data_in), .in2(2'b10), .hd(node3[3:2]));
endmodule

