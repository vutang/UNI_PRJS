module block_ram_count #(
	parameter N = 13)
	(
		input clk,
		input we,
		input [N-1:0] w_addr,
		input [N-1:0] r_addr,
		input [N-6:0] din,
		output reg [N-6:0] dout
	);
	reg [N-6:0] ram [0:2**N-1];
	reg [N-6:0] doo;
	integer i;
	initial begin
		for (i=0; i<2**N; i=i+1) begin 
			ram[i] = 0;
		end
	end
	always @(posedge clk)
	begin
		if (we)
		begin
			ram[w_addr] <= din;
		end
		//else
		//begin
			//doo <= ram[addr];
			//dout <= doo;
		dout <= ram[r_addr];
		//end
	end 
	//assign dout = ram[addr];
endmodule