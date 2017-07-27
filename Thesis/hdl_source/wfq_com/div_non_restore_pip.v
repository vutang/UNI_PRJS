//------------------------------------------------------------
// Author			:	vantubk
// Date				:	2015-04-29 18:56:10
// Last Modified 	:	2015-04-29 20:36:30
// Description		:	bo chia pipeline su dung thuat toan 
// 						non-restore, duoc chinh sua de chia 
// 						so nguyen duong cho so thap phan <1
//------------------------------------------------------------
module div_non_restore_pip #(parameter N = 16) (
	input          clk,
	//input  		   start,
	input  [N-1:0] dividend,
	input  [N-1:0] divisor,
	output [N-1:0] quotient
	//output 		   done
);
	reg [2*N-1:0] A[N:0];
	reg [  N-1:0] B[N:0], Q[N+1:1];
	//--------------------------------------
	//16 chu ki dau cua thuat toan cho ket qua A = A-B,
	//cac chu so cua Q trong 16 chu ki nay deu = 0
	always @(posedge clk) begin
		B[0] <= divisor;
		A[0] <= dividend + {16'hFFFF,~divisor} + 1'b1;
	end
	//--------------------------------------
	always @(posedge clk) begin
		if(A[0][2*N-1] == 1'b1) begin
			Q[1][0] <= 1'b0;
			A[1] 	<= {A[0][2*N-2:0],1'b0} + B[0];
		end 
		else begin
			Q[1][0] <= 1'b1;
			A[1] 	<= {A[0][2*N-2:0],1'b0} + {16'hFFFF,~B[0]} + 1'b1;
		end
		B[1] <= B[0];
	end
	//--------------------------------------
	genvar i;
	generate
		for (i=2; i<=N; i=i+1) begin: pipeline_block
			always @(posedge clk) begin
				if(A[i-1][2*N-1] == 1'b1) begin
					Q[i][0] <= 1'b0;
					A[i] 	<= {A[i-1][2*N-2:0],1'b0} + B[i-1];
				end 
				else begin
					Q[i][0] <= 1'b1;
					A[i] 	<= {A[i-1][2*N-2:0],1'b0} + {16'hFFFF,~B[i-1]} + 1'b1;
				end
				Q[i][N-1:1] <= Q[i-1][N-2:0];
				B[i] 		<= B[i-1];
			end
		end
	endgenerate
	//--------------------------------------
	always @(posedge clk) begin
		if(A[N][2*N-1] == 1'b1) begin
			Q[N+1][0] <= 1'b0;
		end 
		else begin
			Q[N+1][0] <= 1'b1;
		end
		Q[N+1][N-1:1] <= Q[N][N-2:0];
	end
	//--------------------------------------
	assign quotient = Q[N+1];
endmodule