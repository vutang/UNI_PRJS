module block_ram_weight #(
	parameter N = 13)
	(
		input clk,
		input we,
		input [N-1:0] addr,
		input [N+2:0] din,
		output reg [N+2:0] dout
	);
	reg [N+2:0] ram [0:2**N-1];
	reg [N+2:0] doo;
	// //reg [N-1:0] ii;
	initial
	begin
		//-------------------ti le 0.5:0.25:0.125:0.125-------------------
		// ram[13'd0]  = 16'h8000; //0.25
		// ram[13'd1]  = 16'h4000; //0.125
		// ram[13'd2]  = 16'h1FFF;
		// ram[13'd3]  = 16'h2000; //0.5
		// 
		ram[13'd0]  = 16'h8000; 
		ram[13'd1]  = 16'h1999; 
		ram[13'd2]  = 16'h1999; 
		ram[13'd3]  = 16'h4CCC;
	end
	// integer i;
	// initial begin
	// 	ram[0] = 16'h4000;//0.25
	// 	for (i=1; i<17; i=i+1) begin 
	// 		ram[i] = 16'h0CCC;
	// 	end
	// end
	always @(posedge clk)
	begin
		if (we)
		begin
			ram[addr] <= din;
		end
		else
		begin
			//doo <= ram[addr];
			//dout <= doo;
			dout <= ram[addr];
		end
	end 
	//assign dout = ram[addr];
endmodule