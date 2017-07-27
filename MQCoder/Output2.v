module output2
(
	input  rst,
	input [15:0] ByteOutTemp_Out,
	input [7:0] BPTemp_Out,
	input flush,Renorm_BO,AddB,Renorm_BP,
	
	output [15:0] ByteOut,
	output reg [7:0] BP,
	output flush_Out
);
assign ByteOut=((Renorm_BO & AddB)==1)? (ByteOutTemp_Out+1): ByteOutTemp_Out;
assign flush_Out=flush;
always @ (BPTemp_Out or Renorm_BP or rst)
	if (rst)
	BP=0;
	else
		if(Renorm_BP) BP=BPTemp_Out;
		else BP=BP;
endmodule