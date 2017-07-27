//------------------------------------------------------------
// Author			:	vantubk (mod)
// Date				:	2015-05-04 08:02:24
// Last Modified 	:	2015-05-04 08:18:44
// Description		:	
//------------------------------------------------------------

module fwft_fifo #(
	parameter DATA_WIDTH = 4,
	parameter ADDR_WIDTH = 4
) (
	input                         rst,
	input                         clk,
	input                         rd_en,
	input                         wr_en,
	input      [(DATA_WIDTH-1):0] din,
	output                        empty,
	output                        full,
	output reg [(DATA_WIDTH-1):0] dout
);
	// parameter WIDTH = 8;
	//
	reg                    fifo_valid, middle_valid, dout_valid;
	reg [(DATA_WIDTH-1):0] middle_dout;
	//
	wire [(DATA_WIDTH-1):0] fifo_dout;
	wire                    fifo_empty, fifo_rd_en;
	wire                    will_update_middle, will_update_dout;
	//
	// orig_fifo is just a normal (non-FWFT) synchronous or asynchronous FIFO
	syn_fifo #(
		DATA_WIDTH,
		ADDR_WIDTH
	) syn_fifo1 (
		.clk      (clk),
		.rst      (rst),
		.rd_en    (fifo_rd_en),
		.data_out (fifo_dout),
		.wr_en    (wr_en),
		.data_in  (din),
		.empty    (fifo_empty),
		.full     (full)
	);
	//
	assign will_update_middle = fifo_valid && (middle_valid == will_update_dout);
	assign will_update_dout   = (middle_valid || fifo_valid) && (rd_en || !dout_valid);
	assign fifo_rd_en         = (!fifo_empty) && !(middle_valid && dout_valid && fifo_valid);
	assign empty              = !dout_valid;
	//
	always @(posedge clk)
		if (rst)
			begin
				fifo_valid   <= 0;
				middle_valid <= 0;
				dout_valid   <= 0;
				dout         <= 0;
				middle_dout  <= 0;
			end
		else
			begin
				if (will_update_middle) begin
					middle_dout  <= fifo_dout;
				end
				if (will_update_dout) begin
					dout         <= middle_valid ? middle_dout : fifo_dout;
				end
				if (fifo_rd_en) begin
					fifo_valid   <= 1;
				end
				else if (will_update_middle || will_update_dout) begin
					fifo_valid   <= 0;
				end
				if (will_update_middle) begin
					middle_valid <= 1;
				end
				else if (will_update_dout) begin
					middle_valid <= 0;
				end
				if (will_update_dout) begin
					dout_valid   <= 1;
				end
				else if (rd_en) begin
					dout_valid   <= 0;
				end
			end
endmodule