//------------------------------------------------------------
// Author			:	vantubk (mod)
// Date				:	2015-05-03 17:04:28
// Last Modified 	:	2015-05-09 16:34:06
// Description		:	
//------------------------------------------------------------

module syn_fifo #(
	parameter DATA_WIDTH = 4,
	parameter ADDR_WIDTH = 4,
	parameter RAM_DEPTH = (1 << ADDR_WIDTH)
) (
	input                   clk, // Clock input
	input                   rst, // Active high reset
	input  [DATA_WIDTH-1:0] data_in, // Data input
	input                   rd_en, // Read enable
	input                   wr_en, // Write Enable
	// output reg [DATA_WIDTH-1:0] data_out, // Data Output
	output [DATA_WIDTH-1:0] data_out, // Data Output
	output reg              empty, // FIFO empty
	output reg              full      // FIFO full
);
	//-----------Internal variables-------------------
	reg  [ADDR_WIDTH-1:0] wr_pointer;
	reg  [ADDR_WIDTH-1:0] rd_pointer;
	reg  [ADDR_WIDTH:0]   status_cnt;
	wire [DATA_WIDTH-1:0] data_ram;
	reg  [DATA_WIDTH-1:0] first_element, second_element;
	// -----------Variable assignments---------------
	// assign full  = (status_cnt == (RAM_DEPTH - 4));
	// assign empty = (status_cnt == 0);
	//-----------Code Start---------------------------
	always @ (posedge clk or posedge rst) begin : WRITE_POINTER
		if (rst) begin
			wr_pointer <= 0;
		end
		else if (wr_en) begin
			wr_pointer <= wr_pointer + 1;
		end
	end
	//
	always @ (posedge clk or posedge rst) begin : READ_POINTER
		if (rst) begin
			rd_pointer <= 0;
		end
		else if (rd_en) begin
			rd_pointer <= rd_pointer + 1;
		end
	end
	//
	assign data_out = data_ram;
	//
	always @ (posedge clk or posedge rst) begin : STATUS_COUNTER
		if (rst) begin
			status_cnt <= RAM_DEPTH-1;
			// status_cnt <= 0;
			// Read but no write.
		end
		else begin
			if ((rd_en) && !(wr_en) && (status_cnt != 0)) begin
				status_cnt <= status_cnt - 1;
				// Write but no read.
			end
			else if ((wr_en) && !(rd_en) && (status_cnt != RAM_DEPTH)) begin
				status_cnt <= status_cnt + 1;
			end
			full  <= (status_cnt == (RAM_DEPTH - 4))?1'b1:1'b0;
			empty <= (status_cnt == 0)? 1'b1:1'b0;
		end
		//
	
	end
	//
	fifo_ram_dp # (DATA_WIDTH,ADDR_WIDTH) DP_RAM (
		.clk        (clk),
		.wr_pointer (wr_pointer),
		.data_in    (data_in),
		.wr_en      (wr_en),
		.rd_pointer (rd_pointer),
		.data_out   (data_ram),
		.rd_en      (rd_en)
	);
	//
endmodule
