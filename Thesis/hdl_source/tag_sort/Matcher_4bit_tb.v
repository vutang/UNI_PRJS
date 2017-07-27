module Matcher_4bit_tb;

	reg [3:0]  d; 
	reg [15:0] m;
	wire [3:0] n;
	wire r_out;
	wire not_found;

	Matcher_16bit sim1 
		(.d(d), .m(m), .n(n), .r_out(r_out), .not_found(not_found));

	reg [3:0] i, j;

	initial	begin
		m = 16'b0000_0000_0000_1000;
		// for (j = 0; j < 15; j = j + 1) begin		
			for (i = 0; i < 15; i = i + 1) begin
					d = i; #10; 
			end
			// m = m >> 1;
		// end
	end
endmodule