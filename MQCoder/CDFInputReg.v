module CDFInputReg
(
	input 			clk, rst,

	input 			flush,	
	input 	[4:0] 	CXIn,
	input 			DIn,

	output reg 	[4:0] 	CXOut,
	output reg 			DOut,
	output reg 			rst_forward,
	output reg 			flush_forward
);

always @(posedge clk)
begin
	if(rst)
	  	begin
			{CXOut,DOut} 	<= 0;
			flush_forward 	<= 0;
		end
	else
		  begin
			{CXOut,DOut} 	<= {CXIn,DIn};
			flush_forward 	<= flush;
		end
	rst_forward = rst;
end
endmodule
