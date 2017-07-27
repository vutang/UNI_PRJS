module CU
(
	input clk, rst, flush, 

	input [15:0] 	AShifted_IU,
	input [3:0] 	LZ_IU,
	input 			CSel_IU,
	input [15:0]	Qe_value_IU,
	input [4:0] 	CTAdd_IU,
	input [3:0] 	Sub8CT_IU,
	// input [15:0]	AShifted_IU_pre,
	input BFF_BO, BFE_BO,

	output [1:0] Carry, 
	output [1:0] Renor, 
	output [43:0] Cout,
	output [3:0] CTRenorm,
	// output [15:0] AShifted_IU_forward,
	output [43:0] CShift8CT_out,
	output AddB_CU
);

reg [43:0] CReg, CUpdate, CTemp, CVal, CCalTemp;
wire [43:0] CCal;
reg [43:0] CCal_temp;
reg [1:0] RenorTemp;
wire [43:0] CShift8CT;
/*	CReg la thanh ghi C
	CUpdate la output cua C_SELECT
	CTemp la dau ra cua SETBIT, su dung trong truong hop FLUSH
	CVal la dau vao cua khoi C<<8-CT
	CShift8CT la dau ra cua khoi C<<8-CT
	CShiftCTAdd la thanh ghi chua gia tri cua CShift8CT sau khi dich CTAdd
	CShiftCTAdd_renorm la thanh ghi can chinh trong truong hop CTAdd < 8
  	*/

always @(posedge clk)
begin
	if (rst)
		begin
			CReg = 0;
		end
	else 
		begin
			CReg = CCal;
		end
end

always @(CReg or CSel_IU or CUpdate or CTAdd_IU or Carry 
		 or Qe_value_IU or AShifted_IU or flush or Renor 
		 or Carry or CShift8CT or CTRenorm)
begin
	//C_SELECT
	if (CSel_IU)
		CUpdate = CReg + Qe_value_IU;
	else 
		CUpdate = CReg;

	if (flush)
	  begin
	  	// SETBIT
	    CTemp = CReg | 44'hFFFF;
	    if (CTemp >= (CReg + AShifted_IU))
	    	CTemp = CTemp - 44'h8000;		// CTemp is output of SETBIT
	    CVal = CTemp; 				// CVal is input of C<<8-CT, 
	  end
	else
		CVal = CUpdate; 

	// Renor - CARRY_BIT
	if (CTAdd_IU < 8) 
		RenorTemp = 0;
	else if (((CTAdd_IU >= 8) && (CTAdd_IU<15)) || (~Carry[0] && (CTAdd_IU == 15))) 
		RenorTemp = 1;
	else 
		RenorTemp = 2;
	//C_Calculate
	if(RenorTemp==0)
	   CCalTemp=CShift8CT;
	else if(RenorTemp==1 && Carry[0]==1) 
	   CCalTemp={24'b0,CShift8CT[19:0]};
	else if(RenorTemp==1 && Carry[0]==0) 
	   CCalTemp={25'b0,CShift8CT[18:0]};
	else if(RenorTemp==2 && (Carry[0]==1||Carry==2'b10)) 
	   CCalTemp={32'b0,CShift8CT[11:0]};
	else 
	   CCalTemp={33'b0,CShift8CT[10:0]};
end

//-------------------------------------------------------
//Khoi C<<8-CT
//Dich thanh ghi C di mot doan 8 - CT
assign CShift8CT =  (Sub8CT_IU == 8)  ? {CVal[35:0], 8'b0} :
					(Sub8CT_IU == 7)  ? {CVal[36:0], 7'b0} :
					(Sub8CT_IU == 6)  ? {CVal[37:0], 6'b0} :
					(Sub8CT_IU == 5)  ? {CVal[38:0], 5'b0} :
					(Sub8CT_IU == 4)  ? {CVal[39:0], 4'b0} :
					(Sub8CT_IU == 3)  ? {CVal[40:0], 3'b0} :
					(Sub8CT_IU == 2)  ? {CVal[41:0], 2'b0} :
					(Sub8CT_IU == 1)  ? {CVal[42:0], 1'b0} :
							  			 CVal;

//----------------------------------------------
//Khoi C_CALs
//Dich thanh ghi CShift8CT di mot doan CTAdd_IU = CT + LZ-8
//				  			 
assign CCal = 		(CTAdd_IU== 23) ? {CCalTemp[28:0], 15'b0} :
					(CTAdd_IU== 22) ? {CCalTemp[29:0], 14'b0} :
					(CTAdd_IU== 21) ? {CCalTemp[30:0], 13'b0} :
					(CTAdd_IU== 20) ? {CCalTemp[31:0], 12'b0} :
					(CTAdd_IU== 19) ? {CCalTemp[32:0], 11'b0} :
					(CTAdd_IU== 18) ? {CCalTemp[33:0], 10'b0} :
					(CTAdd_IU== 17) ? {CCalTemp[34:0], 9'b0} :
					(CTAdd_IU== 16) ? {CCalTemp[35:0], 8'b0} :
					(CTAdd_IU== 15) ? {CCalTemp[36:0], 7'b0} :
					(CTAdd_IU== 14) ? {CCalTemp[37:0], 6'b0} :
					(CTAdd_IU== 13) ? {CCalTemp[38:0], 5'b0} :
					(CTAdd_IU== 12) ? {CCalTemp[39:0], 4'b0} :
					(CTAdd_IU== 11) ? {CCalTemp[40:0], 3'b0} :
					(CTAdd_IU== 10) ? {CCalTemp[41:0], 2'b0} :
					(CTAdd_IU== 9)  ? {CCalTemp[42:0], 1'b0} :
					(CTAdd_IU== 0)  ? {8'b0, CCalTemp[43:8]} :
					(CTAdd_IU== 1)  ? {7'b0, CCalTemp[43:7]} ://dich phai thanh ghi CShiftCTAdd di 8 - CTAdd 
					(CTAdd_IU== 2)  ? {6'b0, CCalTemp[43:6]} :
					(CTAdd_IU== 3)  ? {5'b0, CCalTemp[43:5]} :
					(CTAdd_IU== 4)  ? {4'b0, CCalTemp[43:4]} :
					(CTAdd_IU== 5)  ? {3'b0, CCalTemp[43:3]} :
					(CTAdd_IU== 6)  ? {2'b0, CCalTemp[43:2]} :
					(CTAdd_IU== 7)  ? {1'b0, CCalTemp[43:1]} :
					  					  CCalTemp;
//assign CCal = (CTAdd_IU >= 8) ? CShiftCTAdd : CShiftCTAdd_renorm;
//------------------------------------------------s
assign CShift8CT_out = ((~BFF_BO) & (CShift8CT >=44'h8000000)& BFE_BO)? (CShift8CT & 44'h7FFFFFF): CShift8CT;
assign AddB_CU = (~BFF_BO) & (CShift8CT >=44'h8000000);
assign Carry[0] = ((((CShift8CT > 28'h800000)) & BFE_BO) | BFF_BO) ? 1'b1 : 1'b0;
assign Carry[1] = ((CShift8CT & 44'h00007F80000) > 44'h00007F80000) ? 1'b1 : 1'b0;
assign Cout = CCalTemp;
assign CTRenorm = (RenorTemp == 2 && Carry[0] == 1'b1) ? ((CTAdd_IU + 1) & 4'b0111) : 
				   (CTAdd_IU & 4'b0111);
assign Renor= (flush==1)? 2 : RenorTemp;
assign AShifted_IU_forward = AShifted_IU;
endmodule
