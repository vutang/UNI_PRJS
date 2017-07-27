module PEReg
(
	input clk, rst, 
	
	input rst_PE, flush_PE,  
	input [15:0] Qe_value_PE,
	input [5:0] NMPS_PE, NLPS_PE,
	input [3:0] LZ0_PE,
	input MPS_update_PE, MPS_coding_PE,
	input [4:0] CX_PE,
	input [5:0] QeIndex_forward,

	output reg [15:0] Qe_value_IU,
	output reg [5:0] NMPS_IU, NLPS_IU,
	output reg [3:0] LZ0_IU,
	output reg MPS_update_IU, MPS_coding_IU,
	output reg [4:0] CX_IU,
	output reg [5:0] QeIndex_forward_IU,
	output reg rst_IU, flush_IU
);

always @(posedge clk)
begin
	if (rst)
		begin
			Qe_value_IU = 0;
			NLPS_IU = 0;
			NMPS_IU = 0;
			LZ0_IU = 0;
			MPS_update_IU = 0;
			MPS_coding_IU = 0;
			CX_IU = 0;
			rst_IU=0;flush_IU=0;
			QeIndex_forward_IU = 0;
		end
	else
		begin
		  rst_IU=rst_PE;flush_IU=flush_PE;
			Qe_value_IU = Qe_value_PE;
			NMPS_IU = NMPS_PE;
			NLPS_IU = NLPS_PE;
			LZ0_IU = LZ0_PE;
			MPS_update_IU = MPS_update_PE;
			MPS_coding_IU = MPS_coding_PE;
			CX_IU = CX_PE;
			QeIndex_forward_IU = QeIndex_forward;
		end
end
endmodule