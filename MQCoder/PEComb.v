module PEComb
(
	input D_CDF,
	input [5:0] QeIndex_CDF,
	input MPS_CDF,
	input Forwarding_CDF,
	input [5:0] SelIndex_IU, //update Next Qe Index
	input MPS_update_IU,	 //is used when Forwarding occupied

	output reg [15:0] Qe_value,
	output reg [5:0] NMPS, NLPS,
	output reg [3:0] LZ0,
	output [5:0] QeIndex_forward,
	output MPS_update,
	output MPS_coding
);

reg [31:0] QeTable [46:0];
initial
begin
	QeTable[0] =  {16'h5601,  6'd1,  6'd1,  4'd1}; 
	QeTable[1] =  {16'h3401,  6'd2,  6'd6,  4'd2}; 
	QeTable[2] =  {16'h1801,  6'd3,  6'd9,  4'd3}; 
	QeTable[3] =  {16'h0AC1,  6'd4,  6'd12, 4'd4};
	QeTable[4] =  {16'h0521,  6'd5,  6'd29, 4'd5}; 
	QeTable[5] =  {16'h0221,  6'd38, 6'd33, 4'd6}; 
	QeTable[6] =  {16'h5601,  6'd7,  6'd6,  4'd1}; 
	QeTable[7] =  {16'h5401,  6'd8,  6'd14, 4'd1};
	QeTable[8] =  {16'h4801,  6'd9,  6'd14, 4'd1}; 
	QeTable[9] =  {16'h3801,  6'd10, 6'd14, 4'd2}; 
	QeTable[10] = {16'h3001, 6'd11, 6'd17, 4'd2}; 
	QeTable[11] = {16'h2401, 6'd12, 6'd18, 4'd2};
	QeTable[12] = {16'h1C01, 6'd13, 6'd20, 4'd3};	
	QeTable[13] = {16'h1601, 6'd29, 6'd21, 4'd3}; 
	QeTable[14] = {16'h5601, 6'd15, 6'd14, 4'd1}; 
	QeTable[15] = {16'h5401, 6'd16, 6'd14, 4'd1};
	QeTable[16] = {16'h5101, 6'd17, 6'd15, 4'd1}; 
	QeTable[17] = {16'h4801, 6'd18, 6'd16, 4'd1}; 
	QeTable[18] = {16'h3801, 6'd19, 6'd17, 4'd2}; 
	QeTable[19] = {16'h3401, 6'd20, 6'd18, 4'd2};
	QeTable[20] = {16'h3001, 6'd21, 6'd19, 4'd2}; 
	QeTable[21] = {16'h2801, 6'd22, 6'd19, 4'd2}; 
	QeTable[22] = {16'h2401, 6'd23, 6'd20, 4'd2}; 
	QeTable[23] = {16'h2201, 6'd24, 6'd21, 4'd2};
	QeTable[24] = {16'h1C01, 6'd25, 6'd22, 4'd3}; 
	QeTable[25] = {16'h1801, 6'd26, 6'd23, 4'd3}; 
	QeTable[26] = {16'h1601, 6'd27, 6'd24, 4'd3}; 
	QeTable[27] = {16'h1401, 6'd28, 6'd25, 4'd3};
	QeTable[28] = {16'h1201, 6'd29, 6'd26, 4'd3}; 
	QeTable[29] = {16'h1101, 6'd30, 6'd27, 4'd3}; 
	QeTable[30] = {16'h0AC1, 6'd31, 6'd28, 4'd4}; 
	QeTable[31] = {16'h09C1, 6'd32, 6'd29, 4'd4};
	QeTable[32] = {16'h08A1, 6'd33, 6'd30, 4'd4};
	QeTable[33] = {16'h0521, 6'd34, 6'd31, 4'd5}; 
	QeTable[34] = {16'h0441, 6'd35, 6'd32, 4'd5}; 
	QeTable[35] = {16'h02A1, 6'd36, 6'd33, 4'd6};
	QeTable[36] = {16'h0221, 6'd37, 6'd34, 4'd6}; 
	QeTable[37] = {16'h0141, 6'd38, 6'd35, 4'd7}; 
	QeTable[38] = {16'h0111, 6'd39, 6'd36, 4'd7}; 
	QeTable[39] = {16'h0085, 6'd40, 6'd37, 4'd8};
	QeTable[40] = {16'h0049, 6'd41, 6'd38, 4'd9};
	QeTable[41] = {16'h0025, 6'd42, 6'd39, 4'd10};
	QeTable[42] = {16'h0015, 6'd43, 6'd40, 4'd11};
	QeTable[43] = {16'h0009, 6'd44, 6'd41, 4'd12};
	QeTable[44] = {16'h0005, 6'd45, 6'd42, 4'd13};
	QeTable[45] = {16'h0001, 6'd45, 6'd43, 4'd15};
	QeTable[46] = {16'h5601, 6'd46, 6'd46, 4'd1};
	// QeTable[47] = {16'h8000, 6'd47, 6'd47, 4'd0};
end	
/*47 elements - each element has 16 bit Qe + 6*2 = 12 bit MPS LPS + 4 bit LZ0*/

//Check Switch
wire [5:0] QeIndex;
wire SW;
wire MPS;

// always @(Forwarding_CDF or SelIndex_IU or QeIndex_CDF or QeIndex or MPS_update_IU or MPS_CDF)
// begin
// 	if (Forwarding_CDF)
// 		begin
// 			QeIndex = SelIndex_IU;
// 		end
// 	else 
// 		begin
// 			QeIndex = QeIndex_CDF;
// 		end
// 	{Qe_value,NMPS,NLPS,LZ0} = QeTable[QeIndex];
// end

//Check SW, NEW-STATE, MPS-CODING
always @(QeIndex)
begin
	{Qe_value,NMPS,NLPS,LZ0} = QeTable[QeIndex];
end

assign QeIndex = (Forwarding_CDF) ? SelIndex_IU : QeIndex_CDF;
assign SW = (QeIndex == 0 || QeIndex == 6 || QeIndex == 14) ? 1'b1 : 1'b0;
assign MPS = (Forwarding_CDF) ? MPS_update_IU : MPS_CDF;
assign MPS_coding = ~(D_CDF ^ MPS);
assign MPS_update = (SW  & ~MPS_coding) ^ MPS;
assign QeIndex_forward = QeIndex;
endmodule

