module Mem_Layer_1 
#(
	parameter 			W = 16
)
(
	input wire			clk, rst,
	input wire 			ena, 

	output reg	[W-1:0]	data_out,
	// update data
	input wire			collision, 
	input wire 	[15:0] 	data_in
);
	
	// declare and initiate memory
	reg [W-1:0] MEM;
	// reg [W-1:0] temp;
	initial begin
		MEM <= 16'h0001;
	end

	// initial
	// begin
	// 		MEM = 16'hFFFF;
	// end

	always @(posedge clk) begin
		if (rst) begin
			data_out <= 16'b0;
			// MEM <= 1;
		end
		else begin
			if (ena) begin
				if (collision)	// update data and read data are the same
					data_out <= MEM | data_in;		
				else 
					data_out <= MEM;
				// temp <= MEM;
			end			
		end
	end
	always @(negedge clk)
		if (rst)
			MEM <= 1;
		else 
			MEM <= MEM | data_in;
	
endmodule 