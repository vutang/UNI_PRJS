module Mem_Layer_2
#(
	parameter 			W = 16,
	parameter 			N = 4
)
(
	input wire			clk, rst,
	input wire 			ena,
	input wire 			ena_foward,

	// read
	input wire 	[N-1:0]	node_address_1, node_address_2,
	output reg 	[W-1:0]	data_out_1, data_out_2,

	// write
	input wire 	[N-1:0] update_node_addr,
	input wire	[15:0] 	update_node_data
);
	
	reg [W-1:0] MEM [0:2**N-1];
	reg [W-1:0] update_node_buffer;

	// initiate Memory
	integer i;
	initial begin
		for (i = 0; i < 2**N; i = i + 1) begin
			if (i == 0) 
				MEM[i] = 1;
			else begin
				MEM[i] = 0;
			end
		end
			
	end

	always @(posedge clk)
	if (rst) begin
		data_out_1 <= 16'b0;
		data_out_2 <= 16'b0;
		update_node_buffer <=  0;
	end
	else begin
		if (ena) begin
			if (update_node_addr == node_address_1) begin
				data_out_1 <= MEM[node_address_1] | update_node_data;	
			end
			else begin
				data_out_1 <= MEM[node_address_1];
			end
			// data_out_1 <= MEM[node_address_1];
			if (update_node_addr == node_address_2) begin
				data_out_2 <= MEM[node_address_2] | update_node_data;
			end
			else begin
				data_out_2 <= MEM[node_address_2];
			end
			// data_out_2 <= MEM[node_address_2];

			// update_node_buffer <=  MEM[update_node_addr];	
		end		
	end

	
	always @(posedge clk) begin	
		// if (ena_foward)	
			MEM[update_node_addr] <=  MEM[update_node_addr] | update_node_data;
	end 
endmodule

// reg [15:0] mask = 16'h0000;

// 	always @(update_node_data)
// 		case (update_node_data)
// 			4'd0:  	mask <= 16'h0001;
// 			4'd1: 	mask <= 16'h0002;
// 			4'd2: 	mask <= 16'h0004;
// 			4'd3: 	mask <= 16'h0008;
// 			4'd4: 	mask <= 16'h0010;
// 			4'd5: 	mask <= 16'h0020;
// 			4'd6: 	mask <= 16'h0040;
// 			4'd7: 	mask <= 16'h0080;
// 			4'd8: 	mask <= 16'h0100;
// 			4'd9: 	mask <= 16'h0200;
// 			4'd10: 	mask <= 16'h0400;
// 			4'd11: 	mask <= 16'h0800;
// 			4'd12: 	mask <= 16'h1000;
// 			4'd13: 	mask <= 16'h2000;
// 			4'd14: 	mask <= 16'h4000;
// 			4'd15: 	mask <= 16'h8000;
// 			default: mask <= 0;
// 		endcase
