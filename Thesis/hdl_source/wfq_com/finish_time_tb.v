`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:02:34 05/01/2015
// Design Name:   finish_time
// Module Name:   E:/WFQ_Computation_ver2/source/finish_time_tb.v
// Project Name:  WFQ_Computation_ver2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: finish_time
////////////////////////////////////////////////////////////////////////////////

module finish_time_tb;

	// Inputs
	reg clk;
	reg start;
	reg flow_idle;
	reg [15:0] packet_l;
	reg [15:0] flow_w;
	reg [15:0] vtime;
	reg [12:0] flow_id;

	// Outputs
	wire [15:0] ftime;
	wire done_ftime;

	// Instantiate the Unit Under Test (UUT)
	finish_time uut (
		.clk(clk), 
		.start(start),
		.flow_idle(flow_idle),
		.packet_l(packet_l), 
		.flow_w(flow_w), 
		.vtime(vtime), 
		.flow_id(flow_id), 
		.ftime(ftime), 
		.done_ftime(done_ftime)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		start = 0;
		flow_idle = 0;
		packet_l = 0;
		flow_w = 0;
		vtime = 0;
		flow_id = 0;

		// Wait 100 ns for global reset to finish
		#100;
		start = 1;
		flow_idle = 1;
		packet_l = 16'd20;
		flow_w = 16'hC000;
		vtime = 16'h0004;
		flow_id = 13'd156;
		#10;
		start = 0;
		flow_idle = 0;
		packet_l = 0;
		flow_w = 0;
		vtime = 0;
		flow_id = 0;
		#10;
		start = 1;
		flow_idle = 0;
		packet_l = 16'd15;
		flow_w = 16'h4000;
		vtime = 16'd16;
		flow_id = 13'd156;
		#10;
		start = 0;
		flow_idle = 0;
		packet_l = 0;
		flow_w = 0;
		vtime = 0;
		flow_id = 0;
		#10;
		start = 1;
		flow_idle = 1;
		packet_l = 16'd16;
		flow_w = 16'h8000;
		vtime = 16'd20;
		flow_id = 13'd80;
		#10;
		start = 0;
		flow_idle = 0;
		packet_l = 0;
		flow_w = 0;
		vtime = 0;
		flow_id = 0;
		#10;
		start = 1;
		flow_idle = 1;
		packet_l = 16'd20;
		flow_w = 16'h4000;
		vtime = 16'd24;
		flow_id = 13'd125;
		#10;
		start = 0;
		flow_idle = 0;
		packet_l = 0;
		flow_w = 0;
		vtime = 0;
		flow_id = 0;
		#10;
		start = 1;
		packet_l = 16'd16;
		flow_w = 16'hC000;
		vtime = 16'd30;
		flow_id = 13'd156;
		#10;
		start = 0;
		packet_l = 0;
		flow_w = 0;
		vtime = 0;
		flow_id = 0;
		#10;
		start = 1;
		flow_idle = 1;
		packet_l = 16'd8;
		flow_w = 16'h8000;
		vtime = 16'd36;
		flow_id = 13'd100;
		#10;
		start = 0;
		flow_idle = 0;
		packet_l = 0;
		flow_w = 0;
		vtime = 0;
		flow_id = 0;
		#10;
		start = 1;
		packet_l = 16'd10;
		flow_w = 16'hC000;
		vtime = 16'd40;
		flow_id = 13'd156;
		#10;
		start = 0;
		packet_l = 0;
		flow_w = 0;
		vtime = 0;
		flow_id = 0;
		#10;
		start = 1;
		packet_l = 16'd16;
		flow_w = 16'h4000;
		vtime = 16'd45;
		flow_id = 13'd125;
		#10;
		start = 0;
		packet_l = 0;
		flow_w = 0;
		vtime = 0;
		flow_id = 0;
		#10;
		start = 1;
		packet_l = 16'd15;
		flow_w = 16'h4000;
		vtime = 16'd50;
		flow_id = 13'd125;
		#10;
		start = 0;
		packet_l = 0;
		flow_w = 0;
		vtime = 0;
		flow_id = 0;
		#10;
		start = 1;
		packet_l = 16'd8;
		flow_w = 16'h8000;
		vtime = 16'd54;
		flow_id = 13'd100;
		#10;
		start = 0;
		packet_l = 0;
		flow_w = 0;
		vtime = 0;
		flow_id = 0;
		#10;
		start = 1;
		packet_l = 16'd20;
		flow_w = 16'h8000;
		vtime = 16'd100;
		flow_id = 13'd80;
		#10;
		start = 0;
		packet_l = 0;
		flow_w = 0;
		vtime = 0;
		flow_id = 0;  
		// Add stimulus here

	end
   always begin
		#5; clk = ~clk;
	end
endmodule

