module track_trellis
(
	input clk, rst, st,
	input [1:0] node,
	input [1:0] flag,
	output reg [1:0] next_node,
	output reg data_out,
	output done
);

//assign next_node = () ;

always @*
	begin
		next_node = 2'b00;
		data_out = 1'b0;
		// case(node)
		// 	2'b00:
		if (node == 2'b00)
				begin
					if(flag == 2'b10)
						begin
							data_out = 1'b0;
							next_node = 2'b00;
						end
					else if(flag == 2'b01)
						begin
							data_out = 1'b0;
							next_node = 2'b01;
						end
					else 
						begin
							data_out = 1'b1;
							next_node = 2'b11;
						end
				end
			// 2'b01:
		else if (node == 2'b01)
				begin
					if(flag == 2'b10)
						begin
							data_out = 1'b0;
							next_node = 2'b10;
						end
					else if(flag == 2'b01)
						begin
							data_out = 1'b0;
							next_node = 2'b11;
						end
				end
			// 2'b10:
		else if (node == 2'b10)
				begin
					if(flag == 2'b10)
						begin
							data_out = 1'b1;
							next_node = 2'b00;
						end
					else if (2'b01)
						begin
							data_out = 1'b1;
							next_node = 2'b01;
						end
				end
			// 2'b11:
		else if (node == 2'b11)
				begin
					if(flag == 2'b10)
						begin
							data_out = 1'b1;
							next_node = 2'b10;
						end
					else if (flag == 2'b01)
						begin
							data_out = 1'b1;
							next_node = 2'b11;
						end
				end
		// endcase
	end
endmodule
