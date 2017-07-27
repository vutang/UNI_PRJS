module CUReg
(
	input clk, rst,rst_CU,flush_CU,

	input [1:0] Carry_CUComb,
	input [1:0] Renor_CUComb,
	input [43:0] CShift8CT_CUComb,
	input AddB_CU,

	output reg [1:0] Carry,
	output reg [1:0] Renor,
	output reg [43:0] CShift8CT,
	output reg rst_BO,flush_BO, 
	output reg AddB
);

always @(posedge clk)
begin
	if (rst)
		begin
			Carry = 0;
			Renor = 0;
			CShift8CT = 0;
			rst_BO=0;flush_BO=0;
			AddB=0;
		end
	else 
		begin
			Carry = Carry_CUComb;
			Renor = Renor_CUComb;
			CShift8CT = CShift8CT_CUComb;
			rst_BO=rst_CU;flush_BO=flush_CU;
			AddB=AddB_CU;
		end
end
endmodule