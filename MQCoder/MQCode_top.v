module MQCode_top
(
	input 			clk, rst, flush,

	input 	[4:0] 	CXIn,
	input 			DIn,

	output 	[15:0] 	ByteOut,
	output 	[7:0] 	BP,
	output 			flush_out	
);

wire 	[4:0] 	CXOut;
wire 			DOut;
wire 			rst_forward, flush_forward;

wire 	[5:0] 	QeIndex;
wire 	[4:0] 	CX_forward;
wire 			D_forward;
wire 			MPS;
wire 			Forwarding;
wire 			rst_PE,flush_PE;


wire 	[15:0] 	Qe_value;
wire 	[5:0] 	NMPS, NLPS;
wire 	[3:0] 	LZ0;
wire 			MPS_update_PEComb;
wire			MPS_coding;

//PEReg-------------------
wire 	[15:0] 	Qe_value_PEtoIU;
wire 	[5:0] 	NMPS_PEtoIU, NLPS_PEtoIU;
wire 	[3:0] 	LZ0_PEtoIU;
wire 			MPS_coding_PEtoIU;
wire 	[4:0] 	CX_IU;
wire 			rst_IU,flush_IU;
wire			MPS_update_IU;

//IU----------------------
wire 	[5:0] 	SelIndex_IU; //update Next Qe Index
wire 			CSel;
wire 	[3:0] 	LZ;
wire 	[4:0] 	CTAdd;
wire 	[3:0] 	Sub8CT;
wire 	[15:0] 	AShifted;
wire 			SetCT_Reg;
wire 	[3:0] 	CT_renorm_IUreg;
// //IURreg - CU

wire 	[15:0] 	AShifted_IUReg;
wire 	[3:0] 	LZ_IUReg;
wire 			CSel_IUReg;
wire 	[15:0] 	Qe_value_IUReg;
wire 			rst_CU, flush_CU;
wire 			SetCT_IU;
//between CUComb and CURegout

wire 	[1:0] 	Carry_CUComb;
wire 	[1:0] 	Renor_CUComb;
wire 	[43:0] 	CShift8CT_CUComb;
wire 			AddB_CU;
wire 	[3:0] 	CTRenorm_CUComb;
wire 			SetCT_CU;
// //between CUReg and BO

wire 	[1:0] 	Carry_CUReg;
wire 	[1:0] 	Renor_CUReg;
wire 	[43:0] 	CShift8CT_CUReg;
wire 			rst_BO, flush_BO;
wire 			AddB_BO;

// //output BO
wire 			BEF, BFF,Renorm;
wire 	[15:0] 	ByteOutTemp;
wire 	[7:0]	BPTemp;


CDFInputReg mod1 (.clk(clk), .rst(rst),.flush(flush), .rst_forward(rst_forward),
				  .CXIn(CXIn), .DIn(DIn),
				  //output 
				  .CXOut(CXOut), .DOut(DOut),.flush_forward(flush_forward));

CDFComb 	mod2 (.clk(clk), .rst(rst),.flush_forward(flush_forward),
				  .rst_forward(rst_forward),.D(DOut), 
				  .CX(CXOut), .CX_pre(CX_forward), 
				  .CX_update(CX_IU), 
				  .MPS_update(MPS_update_IU), 
				  .QeIndex_update(SelIndex_IU), 
				  //output
				  .flush_PE(flush_PE),.rst_PE(rst_PE),.QeIndex(QeIndex), .CX_forward(CX_forward), 
				  .D_forward(D_forward), .MPS(MPS), .Forwarding(Forwarding));

wire [5:0] QeIndex_forward_PEreg;

PEComb 		mod3 (.D_CDF(D_forward), .QeIndex_CDF(QeIndex),
				  .MPS_CDF(MPS), .Forwarding_CDF(Forwarding), .SelIndex_IU(SelIndex_IU), 
				  .MPS_update_IU(MPS_update_IU), 
				  //output
				  .Qe_value(Qe_value), .NMPS(NMPS), .NLPS(NLPS), .LZ0(LZ0), 
				  .MPS_update(MPS_update_PEComb), .MPS_coding(MPS_coding),
				  .QeIndex_forward(QeIndex_forward_PEreg));

wire [5:0] QeIndex_forward_IU;

PEReg 		mod4 (.clk(clk), .rst(rst),.rst_PE(rst_PE),.flush_PE(flush_PE), 
				  .Qe_value_PE(Qe_value), 
				  .NMPS_PE(NMPS), 
				  .NLPS_PE(NLPS), .LZ0_PE(LZ0), .MPS_update_PE(MPS_update_PEComb), 
				  .MPS_coding_PE(MPS_coding), .CX_PE(CX_forward),
				  .QeIndex_forward(QeIndex_forward_PEreg),
				  //output
				  .flush_IU(flush_IU),.rst_IU(rst_IU),.Qe_value_IU(Qe_value_PEtoIU), 
				  .NMPS_IU(NMPS_PEtoIU), 
				  .NLPS_IU(NLPS_PEtoIU),
				  .LZ0_IU(LZ0_PEtoIU), .MPS_update_IU(MPS_update_IU),
				  .MPS_coding_IU(MPS_coding_PEtoIU), .CX_IU(CX_IU),
				  .QeIndex_forward_IU(QeIndex_forward_IU));

/*IU_150120 			mod5 (.clk(clk), .rst(rst_IU),.flush(flush_IU), .Qe_value_PE(Qe_value_PEtoIU), 
				  .NMPS_PE(NMPS_PEtoIU),
				  .NLPS_PE(NLPS_PEtoIU), .LZ0_PE(LZ0_PEtoIU), 
				  .MPS_coding_PE(MPS_coding_PEtoIU), .CT_renorm_CU(CTRenorm_CUComb),
				  .QeIndex_pre(QeIndex_forward_IU),.SetCT_CU(SetCT_CU),
				  //output
				  .CSel(CSel), .LZ(LZ), .SelIndex(SelIndex_IU), .CTAdd(CTAdd), .Sub8CT(Sub8CT),
				  .AShifted(AShifted),.SetCT(SetCT_Reg));*/

IU_150120 			mod5 (.clk(clk), .rst(rst_IU),.flush(flush_IU), .Qe_value_PE(Qe_value_PEtoIU), 
				  .NMPS_PE(NMPS_PEtoIU),
				  .NLPS_PE(NLPS_PEtoIU), .LZ0_PE(LZ0_PEtoIU), 
				  .MPS_coding_PE(MPS_coding_PEtoIU), 
				  // .CT_renorm_CU(CTRenorm_CUComb),
				  .QeIndex_pre(QeIndex_forward_IU),.SetCT_CU(SetCT_CU),
				  //output
				  .CSel(CSel), .LZ(LZ), .SelIndex(SelIndex_IU), 
				  // .CTAdd(CTAdd), .Sub8CT(Sub8CT),
				  .AShifted(AShifted),.SetCT(SetCT_Reg));

IUReg mod6		(.clk(clk), .rst(rst), .rst_IU(rst_IU), .flush_IU(flush_IU),
				 .AShifted_IU(AShifted), 
				 .LZ_IU(LZ),
				 .CSel_IU(CSel), 
				 // .CTAdd_IU(CTAdd), .Sub8CT_IU(Sub8CT),
				 .Qe_value_IU(Qe_value_PEtoIU),.SetCT(SetCT_Reg),
				 .CT_renorm_fromCU(CTRenorm_CUComb),
				 //output
				 .rst_CU(rst_CU),.flush_CU(flush_CU),.AShifted_CU(AShifted_IUReg), .LZ_CU(LZ_IUReg), 
				 .CSel_CU(CSel_IUReg),
				 // .CTAdd_CU(CTAdd_IUReg), .Sub8CT_CU(Sub8CT_IUReg), 
				 .CT_renorm_toCU(CT_renorm_IUreg),
				 .Qe_value_CU(Qe_value_IUReg),.SetCT_IU(SetCT_IU));

CU_new    mod7		(.clk(clk), .rst(rst_CU), .AShifted_IU(AShifted_IUReg), .LZ_IU(LZ_IUReg),
				 .CSel_IU(CSel_IUReg), .Qe_value_IU(Qe_value_IUReg), 
				 // .CTAdd_In(CTAdd_IUReg), .Sub8CT_In(Sub8CT_IUReg), 
				 .CT_renorm_IUReg(CT_renorm_IUreg),
				 .BFF_BO(BFF),
				 .BFE_BO(BEF), .flush(flush_CU),.SetCT_IU(SetCT_IU),
				 //output
				 .Carry(Carry_CUComb), .Renorm(Renor_CUComb),
				 .CTRenorm(CTRenorm_CUComb), .CShift8CT_out(CShift8CT_CUComb),.AddB_CU(AddB_CU),
				 .SetCT_CU(SetCT_CU)
				 );


CUReg  mod8		(.clk(clk), .rst(rst),.rst_CU(rst_CU), .flush_CU(flush_CU), 
				 .Carry_CUComb(Carry_CUComb), 
				 .Renor_CUComb(Renor_CUComb), .CShift8CT_CUComb(CShift8CT_CUComb),.AddB_CU(AddB_CU),
				 //output
				 .rst_BO(rst_BO),.flush_BO(flush_BO),.Carry(Carry_CUReg), .Renor(Renor_CUReg), 
				 .CShift8CT(CShift8CT_CUReg),.AddB(AddB_BO));


BO     mod9		(.clk(clk), .rst(rst_BO), .CShift8CT_CU(CShift8CT_CUReg),
				 .Renorm_CU(Renor_CUReg), .Carry_CU(Carry_CUReg),
				 // .flush(flush_BO),
				 // .flush_in(flush_out),
				 //output 
				 .ByteOutTemp(ByteOutTemp), .BEF(BEF), .BFF(BFF), .BPTemp(BPTemp),.Renorm(Renorm));
	
Output	mod10  (.clk(clk),.rst(rst),.ByteOutTemp(ByteOutTemp), .BPTemp(BPTemp),
					.Renorm(Renorm),.AddB(AddB_BO),.flush(flush_BO),
					.ByteOut(ByteOut),.BP(BP),.flush_out(flush_out));
endmodule