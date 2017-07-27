//------------------------------------------------------------
// Author			:	vantubk
// Date				:	2015-04-08 22:08:14
// Last Modified 	:	2015-05-28 18:17:58
// Description		:	2^13 x 72 bit dual port ram
//------------------------------------------------------------
module dualport_shared_ram #(
	parameter SHARED_BUFFER_ADDR_BITWIDTH = 13,
	parameter SHARED_BUFFER_DATA_BITWIDTH = 72  +13+1
) (
	input                                        clk, // Clock
	input                                        rd_en,
	input                                        wr_en,
	input      [SHARED_BUFFER_ADDR_BITWIDTH-1:0] r_addr,
	input      [SHARED_BUFFER_ADDR_BITWIDTH-1:0] w_addr,
	input      [SHARED_BUFFER_DATA_BITWIDTH-1:0] w_data,
	output reg [SHARED_BUFFER_DATA_BITWIDTH-1:0] r_data
);
	reg [SHARED_BUFFER_DATA_BITWIDTH-1:0] dp_ram[2**SHARED_BUFFER_ADDR_BITWIDTH-1:0];
	//--
	always @(posedge clk) begin
		if(rd_en) begin
			r_data         <= dp_ram[r_addr];
		end
		if(wr_en) begin
			dp_ram[w_addr] <= w_data;
		end
	end
endmodule