module virtual_time #(
	parameter N=16)
	(
		input clk,
		input rst,
		input start,
		input [N-1:0] delta_t,
		input [N-1:0] sum_weight,
		output reg [N-1:0] ovtime
	);
	reg done, start_b;
	reg [N-1:0] dividend;
	reg [N-1:0] dividend_d[19:0];
	reg [N-1:0] divisor;
	wire [N-1:0] quotient;
	//reg [N-1:0] iadd1=0, iadd2=0, oadd=0, vtime = 0;
	reg [N-1:0] iadd1, iadd2, oadd, vtime;
	//reg start_b;  
	reg start_b1, start_b7 , start_b13;
	reg start_b2, start_b8 , start_b14;
	reg start_b3, start_b9 , start_b15;
	reg start_b4, start_b10, start_b16;
	reg start_b5, start_b11, start_b17;
	reg start_b6, start_b12, start_b18;
	
	div_non_restore_pip uut (
		.clk      (clk),
		.dividend (dividend),
		.divisor  (divisor),
		.quotient (quotient)
	);
	//dividend delay
	//genvar i;
	//generate
	//	for(i=1; i<20; i=i+1) begin: dividend_delay_block
	//		always @(posedge clk) begin
	//			dividend_d[i] <= dividend_d[i-1];
	//		end
	//	end
	//endgenerate
	//always @(posedge clk) begin
	//	dividend_d[0] <= dividend;
	//end
	//
	always @(posedge clk) begin
		start_b1 <= start;			start_b7  <= start_b6;			start_b13 <= start_b12;
		start_b2 <= start_b1;		start_b8  <= start_b7;			start_b14 <= start_b13;
		start_b3 <= start_b2;		start_b9  <= start_b8;			start_b15 <= start_b14;
		start_b4 <= start_b3;		start_b10 <= start_b9;			start_b16 <= start_b15;
		start_b5 <= start_b4;		start_b11 <= start_b10;			start_b17 <= start_b16;
		start_b6 <= start_b5;		start_b12 <= start_b11;			//start_b18 <= start_b17;
		start_b  <= start_b17;
		done <= start_b;
		// ---------------------
		if (rst) begin
			//iadd1 <= 0;
			//iadd2 <= 0;
			vtime <= 0;
		end
		else begin
			if (done) begin
				//iadd2 <= vtime;
				//iadd1 <= quotient;
				// iadd1 <= dividend_d[17];
				vtime <= vtime + quotient;
			end
		end
		if (start) begin
			dividend <= {2'b00,delta_t[N-1:2]};
			// dividend <= delta_t;
			divisor <= sum_weight;
		end
		
		//vtime <= iadd1 + iadd2;
		//oadd <= iadd1 + iadd2;
		//ovtime <= iadd1 + iadd2;
		ovtime <= vtime;
	end 
endmodule