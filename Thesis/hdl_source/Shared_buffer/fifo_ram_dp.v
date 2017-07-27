//------------------------------------------------------------
// Author			:	vantubk
// Date				:	2015-05-03 17:06:32
// Last Modified 	:	2015-05-06 12:07:13
// Description		:	
//------------------------------------------------------------
module fifo_ram_dp #(parameter
	DATA_WIDTH = 4,
	ADDR_WIDTH = 4
) (
	input                       clk, // Clock
	input      [ADDR_WIDTH-1:0] wr_pointer,
	input      [DATA_WIDTH-1:0] data_in,
	input                       wr_en,
	input      [ADDR_WIDTH-1:0] rd_pointer,
	output reg [DATA_WIDTH-1:0] data_out,
	input                       rd_en
);
	localparam RAM_DEPTH = 2**ADDR_WIDTH;
	reg [DATA_WIDTH-1:0] mem [0:RAM_DEPTH-1];
	// initial $readmemb ("fifo_ram_dp.hex", mem);//initial dada for ram. can be synthesis and simulate
	// initial dada for ram. can be synthesis and simulate
	reg [DATA_WIDTH:0] i;
	initial begin 
		for (i=0; i<=(1<<DATA_WIDTH - 1);i=i+1) begin
			mem[i] = i[DATA_WIDTH-1:0];
		end
	end
	//
	always @(posedge clk) begin
		if(wr_en) begin //write data
			mem[wr_pointer] <= data_in;
		end
		if(rd_en) begin //read data
			data_out <= mem[rd_pointer];
		end
	end
endmodule