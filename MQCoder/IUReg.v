module IUReg
(
	input clk, rst,
	input rst_IU,flush_IU, 

	input 	[15:0] 	AShifted_IU, 
	input 	[3:0] 	LZ_IU,
	input 			CSel_IU,
	// input 	[4:0] 	CTAdd_IU,
	// input 	[3:0] 	Sub8CT_IU,
	input 	[15:0] 	Qe_value_IU,
	input 			SetCT,
	input 	[3:0] 	CT_renorm_fromCU, 


	output reg 	[15:0] 	AShifted_CU,
	output reg 	[3:0] 	LZ_CU,
	output reg 			CSel_CU,
	// output reg 	[4:0] 	CTAdd_CU,
	// output reg 	[3:0] 	Sub8CT_CU,
	output reg 	[15:0] 	Qe_value_CU,
	output reg 			rst_CU, flush_CU,
	output reg 			SetCT_IU,
	output reg	[3:0] 	CT_renorm_toCU 
);

always @(posedge clk)
begin
	if (rst)
		begin
			AShifted_CU 	<= 0;
			LZ_CU 			<= 0;
			CSel_CU 		<= 0;
			// CTAdd_CU 		<= 0;
			// Sub8CT_CU 		<= 0;
			Qe_value_CU 	<= 0;
			rst_CU			<= 0;
			flush_CU		<= 0;
			SetCT_IU		<= 0;
			CT_renorm_toCU 	<= 0;
		end
	else 
		begin
			AShifted_CU 	<= AShifted_IU;
			LZ_CU 			<= LZ_IU;
			CSel_CU 		<= CSel_IU;
			// CTAdd_CU 		<= CTAdd_IU;
			// Sub8CT_CU 		<= Sub8CT_IU;
			Qe_value_CU 	<= Qe_value_IU;
			rst_CU			<= rst_IU;
			flush_CU		<= flush_IU;
			SetCT_IU 		<= SetCT;
			CT_renorm_toCU	<= CT_renorm_fromCU;
		end
end

endmodule