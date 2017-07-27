module Trans_Table
#(
	parameter 	N = 12,
				W = 16
)
(
	input wire 					clk, 		// clock and reset signal
	input wire 					rst,

	input wire 					rd_req,
	input wire 	[N-1:0] 		rd_addr,

	input wire 					wr_req,
	input wire 	[N-1:0]			wr_addr,
	input wire 	[W-1:0]			wr_data,	

	output reg 	[W-1:0] 		rd_data	
);

	reg [W-1:0] TABLE [0:2**N-1];

	integer i;
	initial begin
		for (i = 0; i < 2**N-1; i = i + 1) begin
			TABLE[i] = 0;
		end
	end

	always @(posedge clk) begin
		if (rst) begin 
			rd_data <= 0;
		end 
		else if (rd_req) begin
			rd_data <= TABLE[rd_addr];	
		end
	end

	always @(negedge clk) begin
		if (wr_req)	begin 
			TABLE[wr_addr] <= wr_data;
		end
	end
endmodule 