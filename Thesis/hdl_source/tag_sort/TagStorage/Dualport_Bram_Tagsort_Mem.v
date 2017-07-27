//------------------------------------------------------------
// Author			:	vantubk
// Date				:	2015-04-16 15:23:48
// Last Modified 	:	2015-06-06 16:49:31
// Description		:	
//------------------------------------------------------------
module  Dualport_Bram_Tagsort_Mem 
#(
	parameter N = 13,		// number of bit in MEM addr
	parameter B = 64		// number of bit in Block
) 
(
	input 						clk,    // Clock
	input 			[N-1:0] 	r_addr1,	
	input 			[N-1:0] 	r_addr2,
	input 						wr_en,	
	input 			[N-1:0] 	w_addr,	
	input 			[B-1:0] 	w_data,	
	output reg 		[B-1:0] 	r_data1,
	output reg 		[B-1:0] 	r_data2
);
	
	reg [B-1:0] RAM [2**N-1:0];
	integer i;
	initial 
		begin
			RAM[0] = 2**N-1;
			for (i = 1; i < 2**N; i = i + 1)
				RAM[i] <= 1+i;			
		end			
	// test 16 block * 16 bit/block
	always @(posedge clk) begin
		r_data1 <= RAM[r_addr1];
		r_data2 <= RAM[r_addr2];
		if(wr_en)
			RAM[w_addr] <= w_data;
	end

endmodule