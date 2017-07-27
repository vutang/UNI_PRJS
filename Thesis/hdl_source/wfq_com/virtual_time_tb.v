`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:34:46 04/29/2015
// Design Name:   virtual_time
// Module Name:   E:/WFQ_Computation_ver2/source/virtual_time_tb.v
// Project Name:  WFQ_Computation_ver2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: virtual_time
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module virtual_time_tb;

	// Inputs
	reg clk;
	reg rst;
	reg start;
	reg [15:0] delta_t;
	reg [15:0] sum_weight;

	// Outputs
	wire [15:0] ovtime;

	// Instantiate the Unit Under Test (UUT)
	virtual_time uut (
		.clk(clk),
		.rst(rst),
		.start(start),
		.delta_t(delta_t), 
		.sum_weight(sum_weight), 
		.ovtime(ovtime)
	);

	initial begin
		rst = 0;
		#10;
		rst = 1;
		#10;
		rst = 0;
	end
	initial begin
		// Initialize Inputs
		clk = 0;
		start = 0;
		delta_t = 0;
		sum_weight = 0;

		// Wait 100 ns for global reset to finish
		#100;
		start = 1;
		delta_t = 16'h0003;
		sum_weight = 16'h8000;
		//#10;
		//start = 0;
		//delta_t = 0;
		//sum_weight = 0;
		#10;
		start = 1;
		delta_t = 16'h0005;
		sum_weight = 16'hC000;
		//#10;
		//start = 0;
		//delta_t = 0;
		//sum_weight = 0;
		#10;
		start = 1;
		delta_t = 16'h0004;
		sum_weight = 16'h4000;
		//#10;
		//start = 0;
		//delta_t = 0;
		//sum_weight = 0;
		#10;
		start = 1;
		delta_t = 16'h0008;
		sum_weight = 16'hFFFF;
		#10;
		start = 0;
		delta_t = 0;
		sum_weight = 0;
		// Add stimulus here
	end
   always begin
		#5; clk = ~clk;
	end
endmodule

