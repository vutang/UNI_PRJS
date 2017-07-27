// `timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HUST
// Engineer: VuTang
// 
// Create Date:    04:06:55 04/17/2015 
// Design Name: 
// Module Name:    Ripple_of_Matcher 
// Project Name: 	Multibit Tree
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Ripple_of_Matcher
(
	input wire	d, m, r_in,
	output wire	n, r_out
);

	wire	[2:0] in;

	// always @(d, m, r_in)
	// begin
	// 	case ({d,m,r_in})
	// 		3'b000: {r_out, n} = 2'b00;
	// 		3'b001: {r_out, n} = 2'b10;
	// 		3'b010: {r_out, n} = 2'b00;
	// 		3'b011: {r_out, n} = 2'b11;
	// 		3'b100: {r_out, n} = 2'b10;
	// 		// 3'b101: {r_out, n} = 2'bxx;
	// 		3'b110: {r_out, n} = 2'b11;
	// 		// 3'b111: {r_out, n} = 2'bxx;
	// 		default: {r_out, n} = 2'b00;
	// 	endcase
	// end

	assign in = {d, m, r_in};
	assign {r_out, n} = (in == 3'b000) ? 2'b00 :
						(in == 3'b001) ? 2'b10 :
						(in == 3'b010) ? 2'b00 :
						(in == 3'b011) ? 2'b11 :
						(in == 3'b100) ? 2'b10 :
						(in == 3'b110) ? 2'b11 :
						2'b00;

endmodule
