module CDFComb
(
	input clk, rst,rst_forward,flush_forward,
	input D,
	input [4:0] CX, CX_pre,
	input [4:0] CX_update,
	input MPS_update,
	input [5:0] QeIndex_update,

	output reg [5:0] QeIndex,
	output reg [4:0] CX_forward,
	output reg D_forward,
	output reg MPS,
	output reg Forwarding,
	output reg rst_PE, flush_PE 
	//test
);

reg [6:0] ContextTable [18:0];
initial
begin
	ContextTable[0]  = {6'd0,1'b0}; 
	ContextTable[1]  = {6'd0,1'b0}; 
	ContextTable[2]  = {6'd0,1'b0};
	ContextTable[3]  = {6'd0,1'b0}; 
	ContextTable[4]  = {6'd0,1'b0};
	ContextTable[5]  = {6'd0,1'b0}; 
	ContextTable[6]  = {6'd0,1'b0};
	ContextTable[7]  = {6'd0,1'b0}; 
	ContextTable[8]  = {6'd0,1'b0};
	ContextTable[9]  = {6'd0,1'b0}; 
	ContextTable[10] = {6'd0,1'b0};
	ContextTable[11] = {6'd0,1'b0}; 
	ContextTable[12] = {6'd0,1'b0};
	ContextTable[13] = {6'd0,1'b0}; 
	ContextTable[14] = {6'd0,1'b0};
	ContextTable[15] = {6'd0,1'b0}; 
	ContextTable[16] = {6'd0,1'b0};
	ContextTable[17] = {6'd0,1'b0}; 
	ContextTable[18] = {6'd0,1'b0};
end
/*
-> {6'd19,1'b1} contexts so we need 5 bit for address
-> 49 Qe elements >> 7 bit
*/
//assign Forwarding = (CX ^ CX_pre) ? 1'b0 : 1'b1;

always @(posedge clk)
begin
	if (rst)
		begin
			// {QeIndex,MPS} 	= {7'd47, 1'b0};
			{QeIndex, MPS}  = 0;
			CX_forward 		= 0;
			D_forward 		= 0;
			Forwarding 		= 0;
			rst_PE = 0; 
			flush_PE = 0;
		end
	else
		begin
		  rst_PE = rst_forward;
		  flush_PE = flush_forward;
			if ((CX ^ CX_update))
				begin 
					{QeIndex,MPS} = ContextTable[CX];
				end
			else
				begin
					{QeIndex,MPS} = {QeIndex_update, MPS_update};
				end
			if (CX ^ CX_pre)	
				Forwarding = 1'b0;
			else 
				Forwarding = 1'b1;

			CX_forward = CX;
			D_forward = D;
			ContextTable[CX_update] = {QeIndex_update, MPS_update};
		end
end
endmodule
