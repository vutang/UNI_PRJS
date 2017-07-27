module BO
(
	input clk, rst, 

	input [43:0] CShift8CT_CU,
	input [1:0] Renorm_CU,
	input [1:0] Carry_CU,

	output reg[15:0] ByteOutTemp,
	output  reg [7:0] BPTemp,
	output BEF, BFF, 
	output Renorm
);

//reg [15:0] BReg;
//reg [15:0] ByteOutTemp;
wire [7:0] BPTemp_In;

always @(posedge clk)
begin
	if (rst )
		BPTemp = 0;	
	else 
		BPTemp = BPTemp_In;	
end

always @(Carry_CU or Renorm_CU or rst or CShift8CT_CU)
begin
	if(rst)
		ByteOutTemp = 0;
	else
		begin
			if (Renorm_CU == 1 && Carry_CU[0] == 1'b1)
			begin
				ByteOutTemp = {8'b0, CShift8CT_CU[27:20]};
			end
			else if (Renorm_CU == 1 && Carry_CU[0] == 1'b0)
				begin
					ByteOutTemp = {8'b0, CShift8CT_CU[26:19]};
				end
			else if (Renorm_CU == 2 && Carry_CU[0] == 1'b1)
				begin
					ByteOutTemp = CShift8CT_CU[27:12];
				end
			else if (Renorm_CU == 2 && Carry_CU[0] == 1'b0 && Carry_CU[1] == 1'b0)
				begin
					ByteOutTemp = CShift8CT_CU[26:11];
				end
			else if (Renorm_CU == 2 && Carry_CU[0] == 1'b0 && Carry_CU[1] == 1'b1)
				begin
					ByteOutTemp = {CShift8CT_CU[26:19], 1'b0, CShift8CT_CU[18:12]};
				end 
			else ByteOutTemp = ByteOutTemp;
	
			/*case ({Renorm_CU,Carry_CU[0],Carry_CU[1]})
				{2'd1, 1'b1, 1'b0}, {2'd1, 1'b1, 1'b1}:		
					ByteOutTemp = {8'b0, CShift8CT_CU[27:20]};
				{2'd1, 1'b0, 1'b0}, {2'd1, 1'b0, 1'b1}:
					ByteOutTemp = {8'b0, CShift8CT_CU[26:19]};
				{2'd2, 1'b1, 1'b0}, {2'd2, 1'b1, 1'b1}:
					ByteOutTemp = CShift8CT_CU[27:12];
				{2'd2, 1'b0, 1'b0}:
					ByteOutTemp = CShift8CT_CU[26:11];
				{2'd2, 1'b0, 1'b1}:
					ByteOutTemp = {CShift8CT_CU[26:19], 1'b0, CShift8CT_CU[18:12]};
				default: ByteOutTemp = ByteOutTemp;
			endcase*/
		end
end

assign BPTemp_In 	= BPTemp + Renorm_CU;
assign Renorm 		= (Renorm_CU != 0);
assign BFF 			= (ByteOutTemp[7:0] == 8'hFF);// ? 1'b1 : 1'b0;
assign BEF 			= (ByteOutTemp[7:0] == 8'hFE) ;// ? 1'b1 : 1'b0;
endmodule
