`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   02:01:17 04/24/2015
// Design Name:   sum_weight
// Module Name:   E:/WFQ_Computation/source/sum_weight_tb.v
// Project Name:  WFQ_Computation
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: sum_weight
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module sum_weight_tb;

	// Inputs
	reg clk;
	reg rst;
	reg arrival;
	reg depart;
	reg [12:0] flow_id;

	// Outputs
	wire [15:0] sum_w;
	wire [15:0] flow_w;
	wire [15:0] delta_t;
	wire flow_idle;

	// Instantiate the Unit Under Test (UUT)
	sum_weight uut (
		.clk(clk),
		.rst(rst),
		.arrival(arrival), 
		.depart(depart), 
		.flow_id(flow_id), 
		.sum_w(sum_w),
		.flow_w(flow_w),
		.delta_t(delta_t),
		.flow_idle(flow_idle)
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
		arrival = 0;
		depart = 0;
		flow_id = 0;

		// Wait 100 ns for global reset to finish
		#100;
		arrival = 1;
		flow_id = 13'd1;
		#10;
		arrival = 0;
		flow_id = 0;
		#10;
		arrival = 1;
		flow_id = 13'd1;
		#10;
		arrival = 0;
		flow_id = 0;
		#10;
		arrival = 1;
		flow_id = 13'd1;
		#10;
		arrival = 0;
		flow_id = 0;
		#10;
		depart = 1;
		flow_id = 13'd1;
		#10;
		depart = 0;
		flow_id = 0;
		#10;
		depart = 1;
		flow_id = 13'd1;
		#10;
		depart = 0;
		flow_id = 0;
		#10;
		depart = 1;
		flow_id = 13'd1;
		#10;
		depart = 0;
		flow_id = 0;
		#10;
		arrival = 1;
		flow_id = 13'd1;
		#10;
		arrival = 0;
		flow_id = 0;
		#10;
		arrival = 1;
		flow_id = 13'd1;
		#10;
		arrival = 0;
		flow_id = 0;
		#10;
		arrival = 1;
		flow_id = 13'd1;
		#10;
		arrival = 0;
		flow_id = 0;
		#10;
		arrival = 1;
		flow_id = 13'd2;
		#10;
		arrival = 0;
		flow_id = 0;
		#10;
		arrival = 1;
		flow_id = 13'd2;
		#10;
		arrival = 0;
		flow_id = 0;
		#10;
		arrival = 1;
		flow_id = 13'd3;
		#10;
		arrival = 0;
		flow_id = 0;
		#10;
		arrival = 1;
		flow_id = 13'd3;
		#10;
		arrival = 0;
		flow_id = 0;
		#10;
		arrival = 1;
		flow_id = 13'd1;
		#10;
		arrival = 0;
		flow_id = 0;
		#10;
		arrival = 1;
		flow_id = 13'd1;
		#10;
		arrival = 0;
		flow_id = 0;
		#10;
		arrival = 1;
		flow_id = 13'd2;
		#10;
		arrival = 0;
		flow_id = 0;
		#10;
		arrival = 1;
		flow_id = 13'd2;
		#10;
		arrival = 0;
		flow_id = 0;
		#10;
		arrival = 1;
		flow_id = 13'd1;
		#10;
		arrival = 0;
		flow_id = 0;
		#10;
		arrival = 1;
		flow_id = 13'd1;
		#10;
		arrival = 0;
		flow_id = 0;
		#10;
		arrival = 1;
		flow_id = 13'd1;
		#10;
		arrival = 0;
		flow_id = 0;
		#10;
		arrival = 1;
		flow_id = 13'd2;
		#10;
		arrival = 0;
		flow_id = 0;
		#10;
		arrival = 1;
		flow_id = 13'd1;
		#10;
		arrival = 0;
		flow_id = 0;
		#10;
		arrival  = 1;
		flow_id = 13'd2;
		#10;
		arrival  = 0;
		flow_id = 0;
		#10;
		arrival  = 1;
		flow_id = 13'd1;
		#10;
		arrival  = 0;
		flow_id = 0;
		#10;
		arrival  = 1;
		flow_id = 13'd2;
		#10;
		arrival  = 0;
		flow_id = 0;
		#10
		arrival  = 1;
		flow_id = 13'd1;
		#10;
		arrival  = 0;
		flow_id = 0;
		#10;
		arrival  = 1;
		flow_id = 13'd2;
		#10;
		arrival = 0;
		flow_id = 0;
		#10;
		arrival  = 1;
		flow_id = 13'd1;
		#10;
		arrival = 0;
		flow_id = 0;
		#10;
		arrival = 1;
		flow_id = 4;
		#10;
		arrival = 0;
		flow_id = 0;
		#10;
		arrival = 1;
		flow_id = 4;
		#10;
		arrival = 0;
		flow_id = 0;
		#10;
		arrival = 1;
		flow_id = 4;
		#10;
		arrival = 0;
		flow_id = 0;
		#10;
		depart = 1;
		flow_id = 4;
		#10;
		depart = 0;
		flow_id = 0;
		#10;
		depart = 1;
		flow_id = 4;
		#10;
		depart = 0;
		flow_id = 0;
		#10;
		depart = 1;
		flow_id = 4;
		#10;
		depart = 0;
		flow_id = 0;
		// Add stimulus here

	end
   always 
	begin
		#5; clk = ~clk;
	end
endmodule

