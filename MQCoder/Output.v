module Output
(
input 				clk, rst,

input 		[15:0] 	ByteOutTemp,
input 		[7:0] 	BPTemp,
input 				flush, Renorm, AddB,

output 		[15:0] 	ByteOut,
output reg 	[7:0] 	BP,
output reg 			flush_out
);

reg 	[15:0] 	ByteOutBuff;
reg 	[7:0] 	BPBuff;
reg 			Renorm_BP;

always @(posedge clk)
begin
	if (rst)
	begin
		ByteOutBuff 	<= 0;
		BPBuff 			<= 0;
		flush_out 		<= 0;
		Renorm_BP 		<= 0;
	end
	else 
	begin
		flush_out 		<= flush;
		ByteOutBuff 	<= ByteOutTemp;
		BPBuff 			<= BPTemp;	
		Renorm_BP 		<= Renorm;
	end
end

assign ByteOut = ((Renorm & AddB) == 1) ? (ByteOutBuff + 1) : ByteOutBuff;

always @ (BPBuff or Renorm_BP or rst)
begin
	if (rst)
		BP = 0;
	else
		if(Renorm_BP) 
			BP = BPBuff;
		else 
			BP = BP;
end

endmodule