`timescale 1ns / 1ps

module fwft_fifo_tb;

	// Inputs
	reg clk;
	reg rst;
	reg [3:0] data_in;
	reg rd_en;
	reg wr_en;

	// Outputs
	wire [3:0] data_out;
	wire empty;
	wire full;

	// Instantiate the Unit Under Test (UUT)
	fwft_fifo uut (
		.clk(clk), 
		.rst(rst), 
		.din(data_in), 
		.rd_en(rd_en), 
		.wr_en(wr_en), 
		.dout(data_out), 
		.empty(empty), 
		.full(full)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		data_in = 0;
		rd_en = 0;
		wr_en = 0;

		// Wait 100 ns for global reset to finish
		#100;
        #3 rst = 1;
        #10 rst = 0;
		// Add stimulus here
		#10 wr_en = 1; data_in = 'd100;
		#10 wr_en = 1; data_in = 'd301;
		#10 rd_en = 1; wr_en = 0;
		#10 rd_en = 0;
		#10 rd_en = 1;
		#10 rd_en = 0;
		#10 rd_en = 1;
		#10 rd_en = 0;
	end
	always begin 
		#5 clk = ~clk;
	end
      
endmodule

