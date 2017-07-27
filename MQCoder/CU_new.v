module CU_new
(
	input clk, rst, flush, 

	input 	[15:0] 	AShifted_IU,
	input 	[3:0] 	LZ_IU,
	input 			CSel_IU,
	input 	[15:0]	Qe_value_IU,
	input 			BFF_BO, BFE_BO,
	input 			SetCT_IU,
	input 	[3:0] 	CT_renorm_IUReg, 

	output 	[1:0] 	Carry, 
	output 	[1:0] 	Renorm, 
	output 	[3:0] 	CTRenorm,
	output 	[43:0] 	CShift8CT_out,
	output 			AddB_CU,
	output reg 		SetCT_CU
);

wire 	[4:0] 	CTAdd_In;
wire 	[3:0] 	Sub8CT_In;
reg 	[43:0] 	CReg, CCalTemp;
wire 	[43:0]  CUpdate;
wire 	[43:0] 	CCal;
reg 	[1:0] 	RenormTemp;
reg 	[43:0] 	CShift8CT, CShiftLZ;
reg 	[43:0]	NumShiftCT;
reg 	[43:0] 	CmpCarry0;
reg 	[43:0] 	CmpCarry1;
wire 	[43:0] 	CSetBit, CTemp, CVal;

assign CTAdd_In 	= CT_renorm_IUReg + LZ_IU;
assign Sub8CT_In 	= 4'd8 - CT_renorm_IUReg;

always @(posedge clk)
begin
	if (rst)
		begin
			CReg <= 0;
		end
	else 
		begin
			CReg <= CCal;
		end
end

reg [4:0] CTAdd_IU;
reg [3:0] Sub8CT_IU ;

always @(rst or SetCT_IU or CTAdd_In)
begin
	if(rst)
		begin
			SetCT_CU 	= 0;
			CTAdd_IU 	= 0;
			Sub8CT_IU 	= 8;
		end
	else
		if(SetCT_IU == 0 && CTAdd_In >= 4)
			begin
				CTAdd_IU  = CTAdd_In -5'd4;
				Sub8CT_IU = Sub8CT_In + 4'd4; 
				SetCT_CU  = 1;
			end
		else
			begin			
				CTAdd_IU  = CTAdd_In;
				Sub8CT_IU = Sub8CT_In;
				SetCT_CU = SetCT_CU;
			end
end

always @(CTAdd_IU or Carry[0] )
begin
	// Renor - CARRY_BIT
	if (CTAdd_IU < 8) 
		RenormTemp = 0;
	else if (((CTAdd_IU >= 8) & (CTAdd_IU < 15)) | (~Carry[0] & (CTAdd_IU == 15)))
		RenormTemp = 1;
	else 
		RenormTemp = 2;		
end

//C Caculate
always @(RenormTemp or Carry or NumShiftCT)
begin
	case ({RenormTemp,Carry})
	{2'b01,2'b01},{2'b01,2'b11}: 				CCalTemp = {7'b0,NumShiftCT[43:7]};
	{2'b01,2'b00},{2'b01,2'b10}: 				CCalTemp = {8'b0,NumShiftCT[43:8]};
	{2'b10,2'b10},{2'b10,2'b11},{2'b10,2'b01} : CCalTemp = {15'b0,NumShiftCT[43:15]};
	{2'b10,2'b00} :  							CCalTemp = {16'b0,NumShiftCT[43:16]};
	default : 									CCalTemp = 44'hFFFFFFF;
	endcase
end

//Dich C di LZ lan2
always @(LZ_IU or CUpdate)
begin
	case(LZ_IU)
		4'd15: CShiftLZ = {CUpdate[28:0], 15'b0};
		4'd14: CShiftLZ = {CUpdate[29:0], 14'b0};
		4'd13: CShiftLZ = {CUpdate[30:0], 13'b0};
		4'd12: CShiftLZ = {CUpdate[31:0], 12'b0};
		4'd11: CShiftLZ = {CUpdate[32:0], 11'b0};
		4'd10: CShiftLZ = {CUpdate[33:0], 10'b0};
		4'd9:  CShiftLZ = {CUpdate[34:0], 9'b0};
		4'd8:  CShiftLZ = {CUpdate[35:0], 8'b0};
		4'd7:  CShiftLZ = {CUpdate[36:0], 7'b0};
		4'd6:  CShiftLZ = {CUpdate[37:0], 6'b0};
		4'd5:  CShiftLZ = {CUpdate[38:0], 5'b0};
		4'd4:  CShiftLZ = {CUpdate[39:0], 4'b0};	
		4'd3:  CShiftLZ = {CUpdate[40:0], 3'b0};
		4'd2:  CShiftLZ = {CUpdate[41:0], 2'b0};
		4'd1:  CShiftLZ = {CUpdate[42:0], 1'b0};		
		default : CShiftLZ = CUpdate;
	endcase
end

//Dich thanh ghi NumShiftCT di mot doan CT
//			
always @(CTAdd_IU)
begin	  			 
	case(CTAdd_IU) 
		5'd23: NumShiftCT = {21'h7FFFF,23'h7FFFFF} ;
		5'd22: NumShiftCT = {22'h7FFFF,22'h3FFFFF} ;
		5'd21: NumShiftCT = {23'h7FFFF,21'h1FFFFF} ;
		5'd20: NumShiftCT = {24'h7FFFF,20'hFFFFF} ;
		5'd19: NumShiftCT = {25'h7FFFF,19'h7FFFF} ;
		5'd18: NumShiftCT = {26'h7FFFF,18'h3FFFF} ;
		5'd17: NumShiftCT = {27'h7FFFF,17'h1FFFF} ;
		5'd16: NumShiftCT = {28'h7FFFF,16'hFFFF} ;
		5'd15: NumShiftCT = {29'h7FFFF,15'h7FFF} ;
		5'd14: NumShiftCT = {30'h7FFFF,14'h3FFF} ;
		5'd13: NumShiftCT = {31'h7FFFF,13'h1FFF} ;
		5'd12: NumShiftCT = {32'h7FFFF,12'hFFF} ;
		5'd11: NumShiftCT = {33'h7FFFF,11'h7FF} ;
		5'd10: NumShiftCT = {34'h7FFFF,10'h3FF} ;
		5'd9:  NumShiftCT = {35'h7FFFF,9'h1FF} ;
		5'd8:  NumShiftCT = {36'h7FFFF,8'hFF} ;
		5'd7:  NumShiftCT = {37'h7FFFF,7'h7F} ;//dich phai thanh ghi CShiftCTAdd di 8 - CTAdd 
		5'd6:  NumShiftCT = {38'h7FFFF,6'h3F} ;
		5'd5:  NumShiftCT = {39'h7FFFF,5'h1F} ;
		5'd4:  NumShiftCT = {40'h7FFFF,4'hF} ;
		5'd3:  NumShiftCT = {41'h7FFFF,3'h7} ;
		5'd2:  NumShiftCT = {42'h7FFFF,2'h3} ;
		5'd1:  NumShiftCT = {43'h7FFFF,1'h1} ;
		default: NumShiftCT =  44'h7FFFF;
		endcase
end	

// Dich C di 8-CT lan									 
always @(Sub8CT_IU or CVal)
begin
	case (Sub8CT_IU)
		4'd8: CShift8CT = {CVal[35:0],8'b0};
		4'd7: CShift8CT = {CVal[36:0],7'b0};
		4'd6: CShift8CT = {CVal[37:0],6'b0};
		4'd5: CShift8CT = {CVal[38:0],5'b0};
		4'd4: CShift8CT = {CVal[39:0],4'b0};
		4'd3: CShift8CT = {CVal[40:0],3'b0};
		4'd2: CShift8CT = {CVal[41:0],2'b0};
		4'd1: CShift8CT = {CVal[42:0],1'b0};
		default: CShift8CT = CVal;
	endcase
end	

//Dich CmpCarry0								 
always @(Sub8CT_IU)
begin
	case (Sub8CT_IU)
		4'd8: CmpCarry0 = 44'h0080000;
		4'd7: CmpCarry0 = 44'h0100000;
		4'd6: CmpCarry0 = 44'h0200000;
		4'd5: CmpCarry0 = 44'h0400000;
		4'd4: CmpCarry0 = 44'h0800000;
		4'd3: CmpCarry0 = 44'h1000000;
		4'd2: CmpCarry0 = 44'h2000000;
		4'd1: CmpCarry0 = 44'h4000000;
		default: CmpCarry0 = 44'h8000000;
	endcase
end		
//Dich CmpCarry1								 
always @(Sub8CT_IU)
begin
	case (Sub8CT_IU)
		4'd8: CmpCarry1 = 44'h007F800;
		4'd7: CmpCarry1 = 44'h00FF000;
		4'd6: CmpCarry1 = 44'h01FE000;
		4'd5: CmpCarry1 = 44'h03FC000;
		4'd4: CmpCarry1 = 44'h07F8000;
		4'd3: CmpCarry1 = 44'h0FF0000;
		4'd2: CmpCarry1 = 44'h1FE0000;
		4'd1: CmpCarry1 = 44'h3FC0000;
		default: CmpCarry1 = 44'h7F80000;
	endcase
end

	//C_SELECT
assign CUpdate 			= (CSel_IU) ? (CReg + Qe_value_IU) : CReg;								 
assign CShift8CT_out 	= ((~BFF_BO) & (CShift8CT >= 44'h8000000)& BFE_BO)? (CShift8CT & 44'h7FFFFFF): 
							CShift8CT;
assign AddB_CU 			= (~BFF_BO) & (CShift8CT >= 44'h8000000);
assign Carry[0] 		= ((((CUpdate >= CmpCarry0)) & BFE_BO) | BFF_BO) ? 1'b1 : 1'b0;
assign Carry[1] 		= ((CUpdate & CmpCarry1)  ==  CmpCarry1 ) ? 1'b1 : 1'b0;
//CSetbit
assign CSetBit 			= CReg | 44'hFFFF;
assign CTemp 			= (CSetBit >=  (CReg + AShifted_IU))? ( CSetBit-44'h8000) : CSetBit;
assign CVal 			= (flush) ? CTemp : CUpdate;
//assign Carry[0] 		= ((((CShift8CT[43:27]>= 17'd1)) & BFE_BO) | BFF_BO) ? 1'b1 : 1'b0;
//assign Carry[1] 		= (CShift8CT[27:16]  ==  12'h7F8) ? 1'b1 : 1'b0;
assign CTRenorm 		= (RenormTemp  ==  2 && Carry[0]  ==  1'b1) ? ((CTAdd_IU + 1) & 4'b0111) : 
				   			(CTAdd_IU & 4'b0111);
assign Renorm 			= (flush == 1)? 2 : RenormTemp;
assign CCal 			= CCalTemp & CShiftLZ;
endmodule