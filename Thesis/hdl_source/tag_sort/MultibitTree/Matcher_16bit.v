// `timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HUST
// Engineer: VuTang
// 
// Create Date:    04:22:17 04/17/2015 
// Design Name: 
// Module Name:    Matcher_4bit 
// Project Name: 
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
module Matcher_16bit
(
	input wire	[3:0] 	d,		// data in 
	input wire 	[15:0] 	m, 		// data in mem
	output 		[3:0] 	n,		// matching position
	output 				r_out,	// ripple out
	output 				not_found	// not found matching position
);
	
	wire [15:0] r_wire;
	reg  [15:0] decoded_data_in;
	wire [15:0] need_encode_data_out;

	always @(d)
	begin
		case (d)
			4'd0:	decoded_data_in = 16'h0001;
			4'd1:	decoded_data_in = 16'h0002;
			4'd2:	decoded_data_in = 16'h0004;
			4'd3:	decoded_data_in = 16'h0008;
			4'd4:	decoded_data_in = 16'h0010;
			4'd5:	decoded_data_in = 16'h0020;
			4'd6:	decoded_data_in = 16'h0040;
			4'd7:	decoded_data_in = 16'h0080;
			4'd8:	decoded_data_in = 16'h0100;
			4'd9:	decoded_data_in = 16'h0200;
			4'd10:	decoded_data_in = 16'h0400;
			4'd11:	decoded_data_in = 16'h0800;
			4'd12:	decoded_data_in = 16'h1000;
			4'd13:	decoded_data_in = 16'h2000;
			4'd14:	decoded_data_in = 16'h4000;
			4'd15:	decoded_data_in = 16'h8000;
			default:decoded_data_in = 16'd0;
		endcase
	end

	assign n = (need_encode_data_out[0]) ? 4'd15 :
			   (need_encode_data_out[1]) ? 4'd14 :
			   (need_encode_data_out[2]) ? 4'd13 :
			   (need_encode_data_out[3]) ? 4'd12 :
			   (need_encode_data_out[4]) ? 4'd11 :
			   (need_encode_data_out[5]) ? 4'd10 :
			   (need_encode_data_out[6]) ? 4'd9 :
			   (need_encode_data_out[7]) ? 4'd8 :
			   (need_encode_data_out[8]) ? 4'd7 :
			   (need_encode_data_out[9]) ? 4'd6 :
			   (need_encode_data_out[10]) ? 4'd5 :
			   (need_encode_data_out[11]) ? 4'd4 :
			   (need_encode_data_out[12]) ? 4'd3 :
			   (need_encode_data_out[13]) ? 4'd2 :
			   (need_encode_data_out[14]) ? 4'd1 :
			   (need_encode_data_out[15]) ? 4'd0 : 4'd0;

	// decode data in

	Ripple_of_Matcher mod0 
		(.d(decoded_data_in[15]), .m(m[15]), .r_in(1'b0), .n(need_encode_data_out[0]), .r_out(r_wire[0]));

	Ripple_of_Matcher mod1
		(.d(decoded_data_in[14]), .m(m[14]), .r_in(r_wire[0]), .n(need_encode_data_out[1]), .r_out(r_wire[1]));

	Ripple_of_Matcher mod2
		(.d(decoded_data_in[13]), .m(m[13]), .r_in(r_wire[1]), .n(need_encode_data_out[2]), .r_out(r_wire[2]));

	Ripple_of_Matcher mod3
		(.d(decoded_data_in[12]), .m(m[12]), .r_in(r_wire[2]), .n(need_encode_data_out[3]), .r_out(r_wire[3]));

	Ripple_of_Matcher mod4 
		(.d(decoded_data_in[11]), .m(m[11]), .r_in(r_wire[3]), .n(need_encode_data_out[4]), .r_out(r_wire[4]));

	Ripple_of_Matcher mod5
		(.d(decoded_data_in[10]), .m(m[10]), .r_in(r_wire[4]), .n(need_encode_data_out[5]), .r_out(r_wire[5]));

	Ripple_of_Matcher mod6
		(.d(decoded_data_in[9]), .m(m[9]), .r_in(r_wire[5]), .n(need_encode_data_out[6]), .r_out(r_wire[6]));

	Ripple_of_Matcher mod7
		(.d(decoded_data_in[8]), .m(m[8]), .r_in(r_wire[6]), .n(need_encode_data_out[7]), .r_out(r_wire[7]));

	Ripple_of_Matcher mod8 
		(.d(decoded_data_in[7]), .m(m[7]), .r_in(r_wire[7]), .n(need_encode_data_out[8]), .r_out(r_wire[8]));

	Ripple_of_Matcher mod9
		(.d(decoded_data_in[6]), .m(m[6]), .r_in(r_wire[8]), .n(need_encode_data_out[9]), .r_out(r_wire[9]));

	Ripple_of_Matcher mod10
		(.d(decoded_data_in[5]), .m(m[5]), .r_in(r_wire[9]), .n(need_encode_data_out[10]), .r_out(r_wire[10]));

	Ripple_of_Matcher mod11
		(.d(decoded_data_in[4]), .m(m[4]), .r_in(r_wire[10]), .n(need_encode_data_out[11]), .r_out(r_wire[11]));

	Ripple_of_Matcher mod12 
		(.d(decoded_data_in[3]), .m(m[3]), .r_in(r_wire[11]), .n(need_encode_data_out[12]), .r_out(r_wire[12]));

	Ripple_of_Matcher mod13
		(.d(decoded_data_in[2]), .m(m[2]), .r_in(r_wire[12]), .n(need_encode_data_out[13]), .r_out(r_wire[13]));

	Ripple_of_Matcher mod14
		(.d(decoded_data_in[1]), .m(m[1]), .r_in(r_wire[13]), .n(need_encode_data_out[14]), .r_out(r_wire[14]));

	Ripple_of_Matcher mod15
		(.d(decoded_data_in[0]), .m(m[0]), .r_in(r_wire[14]), .n(need_encode_data_out[15]), .r_out(r_wire[15]));

	assign r_out = r_wire[15];
	assign not_found = (need_encode_data_out == 16'b0);

endmodule
