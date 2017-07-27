module Mem_Layer_3
(
	input wire 			clk, rst,
	input wire			ena,

	input wire 	[7:0]	node_address_1, 
	input wire 	[7:0]	node_address_2,
	output reg	[15:0]	data_out_1, 
	output reg 	[15:0] 	data_out_2,
	// update
	input wire 	[7:0] 	update_node_addr,
	input wire 	[15:0] 	update_node_data	
);

	reg [15:0] MEM [0:255]; // 16 * 16 = 255;

	reg [15:0] update_node_data_temp;
	integer i;
	initial	begin
		for (i = 0; i < 256; i = i + 1) begin
			if (i == 0) begin
				MEM[i] = 16'h0001;	
			end
			else begin
				MEM[i] = 0;
			end
		end		
	end

	always @(posedge clk)
		if (rst) begin
			data_out_1 <= 16'b0;
			data_out_2 <= 16'b0;
			update_node_data_temp <= 0;
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
				
				// update_node_data_temp <= MEM[update_node_addr];
			end
		end

	always @(posedge clk) begin		
		MEM[update_node_addr] <= MEM[update_node_addr] | update_node_data;
		// MEM[update_node_addr] <= MEM[update_node_addr] | mask;
	end

endmodule 