`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:23:58 04/26/2015
// Design Name:   wfq_computation
// Module Name:   E:/WFQ_Computation/source/wfq_computation_tb.v
// Project Name:  WFQ_Computation
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: wfq_computation
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module wfq_computation_tb;

	// Inputs
	reg clk;
	reg rst;
	reg arrival;
	reg depart;
	reg [15:0] packet_length;
	reg [12:0] flow_id;

	// Outputs
	wire [15:0] oftime;
	wire odone;

	// Instantiate the Unit Under Test (UUT)
	wfq_computation uut (
		.clk(clk),
		.rst(rst),
		.arrival(arrival), 
		.depart(depart), 
		.packet_length(packet_length), 
		.flow_id(flow_id), 
		.oftime(oftime), 
		.odone(odone)
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
		packet_length = 0;
		flow_id = 0;

		// Wait 2 ns for global reset to finish
		#100;
		// Add stimulus here
		arrival = 1;
		flow_id = 13'd2;
		packet_length = 16'd12;
		#10;
		arrival = 0;
		flow_id = 13'd0;
		packet_length = 16'd0;
		#10;
		arrival = 1;
		flow_id = 13'd1;
		packet_length = 16'd12;
		#10;
		arrival = 0;
		flow_id = 0;
		packet_length = 0;
		#10;
		arrival = 1;
		flow_id = 13'd1;
		packet_length = 16'd8;
		#10;
		arrival = 0;
		flow_id = 0;
		packet_length = 0;
		#10;
		arrival = 1;
		flow_id = 13'd1;
		packet_length = 16'd16;
		#10;
		arrival = 0;
		flow_id = 0;
		packet_length = 0;
		#10;
		depart = 1;
		flow_id = 13'd1;
		packet_length = 16'd15;
		#10;
		depart = 0;
		flow_id = 0;
		packet_length = 0;
		#10;
		depart = 1;
		flow_id = 13'd1;
		packet_length = 16'd10;
		#10;
		depart = 0;
		flow_id = 0;
		packet_length = 0;
		#10;
		depart = 1;
		flow_id = 13'd1;
		packet_length = 16'd15;
		#10;
		depart = 0;
		flow_id = 0;
		packet_length = 0;
		#10;
		arrival = 1;
		flow_id = 13'd1;
		packet_length = 16'd13;
		#10;
		arrival = 0;
		flow_id = 0;
		packet_length = 0;
		#10;
		arrival = 1;
		flow_id = 13'd1;
		packet_length = 16'd11;
		#10;
		arrival = 0;
		flow_id = 0;
		packet_length = 0;
		#10;
		arrival = 1;
		flow_id = 13'd1;
		packet_length = 16'd16;
		#10;
		arrival = 0;
		flow_id = 0;
		packet_length = 0;
		#10;
		arrival = 1;
		flow_id = 13'd1;
		packet_length = 16'd9;
		#10;
		arrival = 0;
		flow_id = 0;
		packet_length = 0;
		#10;
		arrival = 1;
		flow_id = 13'd1;
		packet_length = 16'd20;
		#10;
		arrival = 0;
		flow_id = 0;
		packet_length = 0;
		#10;
		arrival = 1;
		flow_id = 13'd1;
		packet_length = 16'd24;
		#10;
		arrival = 0;
		flow_id = 0;
		packet_length = 0;
	end
   always 
	begin
		#5; clk = ~clk;
	end
endmodule

