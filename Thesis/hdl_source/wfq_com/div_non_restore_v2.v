module div #(parameter N = 16)
	(kq, done, sbc, sc, clk, start);
	//
	output done;
	output [N-1:0] kq;
	input  [N-1:0] sbc, sc;
	input clk, start;
	//
	reg [2*N-1:0] A;
	reg [N-1:0] B, Q, R;
	reg [4:0] count;
	//
	always @(posedge clk) begin
		if(start) begin
			Q 	= 0;
			R 	= 0;
			B   = sc;
			count = 'd0;
			A = sbc + {16'hFFFF,~sc} + 1'b1;
		end
		else begin
			if(A[2*N-1] == 1'b1) begin 
				R[0] = 1'b0;
				{A,Q} = {A,Q}<<1;
				A = A + B;
			end	
			else begin 
				R[0] = 1'b1;
				{A,Q} = {A,Q}<<1;
				A = A + {16'hFFFF,~B} + 1'b1;
			end
			R = R<<1;
		end
		count = count + 1;
	end
	assign kq   = R>>1;
	assign done = (count == N)? 1'b1:1'b0;
endmodule
