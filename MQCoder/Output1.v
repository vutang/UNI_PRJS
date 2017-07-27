module output1
(
	input clk,rst,
	input [15:0] ByteOutTemp,
	input [7:0] BPTemp,
	input flush,Renorm,
	
	output reg [15:0] ByteOutTemp_Out,
	output reg [7:0] BPTemp_Out,
	output reg  flush_Out,Renorm_Out
);
always @(posedge clk)
begin
	if (rst)
	begin
		ByteOutTemp_Out=0;
		BPTemp_Out=0;
		flush_Out=0;
		Renorm_Out=0;
	end
	else
	begin
		ByteOutTemp_Out=ByteOutTemp;
		BPTemp_Out=BPTemp;
		flush_Out=flush;
		Renorm_Out=Renorm;
	end
end
endmodule