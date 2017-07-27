module IU_150120
(
	input clk, rst, flush, 

	input 		[15:0] 	Qe_value_PE, 
	input 		[5:0] 	NMPS_PE, NLPS_PE, 
	input 		[3:0] 	LZ0_PE, 
	input 				MPS_coding_PE, 
	input 		[5:0] 	QeIndex_pre, 
	input 				SetCT_CU, 

	output 				CSel, 
	output reg 	[3:0] 	LZ, 
	output reg 	[5:0] 	SelIndex, 
	output 		[15:0] 	AShifted, 
	output 				SetCT
);

reg 	[15:0] 	AReg;
wire 	[15:0] 	ACal;
reg 	[15:0] 	AShift;
wire 	[15:0] 	ASub; 				//ASub = A - Qe;
wire 			Sel;
wire 			CmpASub1, CmpASub2; // so sanh vs 16'h4000 va 16'h8000

always @(posedge clk)
begin
	if (rst || flush)
		begin
			AReg <= 16'h8000;
		end
	else
		begin
			AReg <= AShift;				
		end
end

always @(Sel or CmpASub1 or CmpASub2 or LZ0_PE)
begin
	case ({Sel, CmpASub1, CmpASub2})
		3'b111: 	LZ = 2;
		3'b101: 	LZ = 1;
		3'b100: 	LZ = 0;
		default : 	LZ = LZ0_PE;
	endcase
end

always @(CmpASub2 or NMPS_PE or NLPS_PE or MPS_coding_PE or QeIndex_pre)
begin
	case ({MPS_coding_PE, CmpASub2})
		2'b11: 		SelIndex = NMPS_PE;
		2'b10: 		SelIndex = QeIndex_pre;
		default : 	SelIndex = NLPS_PE;
	endcase
end

//shift barel
always @(LZ or ACal)
begin
	case (LZ)
		4'd15: 	AShift = {ACal[0], 15'b0};
		4'd14: 	AShift = {ACal[1:0], 14'b0};
		4'd13: 	AShift = {ACal[2:0], 13'b0};
		4'd12: 	AShift = {ACal[3:0], 12'b0};
		4'd11: 	AShift = {ACal[4:0], 11'b0};
		4'd10: 	AShift = {ACal[5:0], 10'b0};
		4'd9: 	AShift = {ACal[6:0], 9'b0};
		4'd8:	AShift = {ACal[7:0], 8'b0};
		4'd7: 	AShift = {ACal[8:0], 7'b0};
		4'd6: 	AShift = {ACal[9:0], 6'b0};
		4'd5: 	AShift = {ACal[10:0], 5'b0};
		4'd4: 	AShift = {ACal[11:0], 4'b0};
		4'd3: 	AShift = {ACal[12:0], 3'b0};
		4'd2: 	AShift = {ACal[13:0], 2'b0};
		4'd1: 	AShift = {ACal[14:0], 1'b0};
		default: AShift = ACal;
	endcase
end

assign ASub 	= AReg - Qe_value_PE;

// assign CmpASub1 = (ASub < 16'h4000);
assign CmpASub1 = ~(ASub[15] == 1'b1 || ASub[14] == 1'b1); 	//0100 0000 0000 0000
// assign CmpASub2 = (ASub < 16'h8000);						
assign CmpASub2 = ~(ASub[15] == 1'b1);						//1000 0000 0000 0000

assign Sel 		= ~((ASub >= Qe_value_PE) ^ MPS_coding_PE);
assign ACal 	= (Sel) ? ASub : Qe_value_PE;
assign CSel 	= Sel;
// assign Sub8CT 	= 4'd8 - CT_renorm_CU;
// assign CTAdd =  (rst) ? 0 : (CT_renorm_CU + LZ);
assign AShifted = AShift;
assign SetCT 	= (~rst) & SetCT_CU;
endmodule