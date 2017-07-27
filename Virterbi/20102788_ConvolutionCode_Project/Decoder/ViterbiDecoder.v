module ViterbiDecoder
#(parameter MAXIMUM_LENGTH_CODE = 9)
(
	input clk, rst, st,
	input [19:0] code_in,
	output [9:0] data_out,
	output reg [6:0] ram_test0, ram_test1, ram_test2, ram_test3,
	output reg [1:0] data_in_test,
	output reg done, done_comp_test,
	output [1:0] node_test,
	output [3:0] base_addr_test,
	output reg [4:0] cnt_test,
	output wire done_compute_test, done_trk_test,
	output reg data_out_trk_test,
	output wire [1:0] flag_trk_test,
	//output [1:0] dataInReg_test [9:0],
	output [2:0] state_test
);

function [1:0] minimum_metric (input [4:0] metric0, metric1, metric2, metric3);
reg [6:0] a, b;	
begin
	if(metric0 <= metric1)
		a = {2'b00, metric0};
	else 
		a = {2'b01, metric1};
	if(metric2 <= metric3)
		b = {2'b10, metric2};
	else 
		b = {2'b11, metric3};
	if(a[4:0] <= b[4:0]) 
		minimum_metric = a[6:5];
	else 
		minimum_metric = b[6:5];
end
endfunction


// have about 10 column (each column has 4 nodes) in trellis
// -maximum metric path = 20 -> 5 bit
// -flag for 2 path each nodes -> 2 bit
// -> we need 7 bit data then we will use 8 bit.

// we have 10*4 = 40 nodes so we need use log2(40) + 1 = 6 bit for address
parameter DATA_WIDTH = 8,
		  ADDR_WIDTH = 6;

//Store trellis information
reg [6:0] RAM [39:0];
//Store input data
reg [1:0] dataInReg [9:0];

//global variable
reg [3:0] base_addr;
reg [0:0] dataout_reg [9:0];

// declaring variables for FSM
parameter	start = 0,
			compute = 1,
			store = 2,
			tracking = 3,
			decode = 4,
			finish = 5;
reg [2:0] state, next_state;

//variables for compute state
reg start_compute;
wire done_compute;
reg [7:0] data_in0_com, data_in1_com, data_in2_com, data_in3_com;
wire [7:0] data_out0_com, data_out1_com, data_out2_com, data_out3_com;
reg [7:0] data_out0_com_buf, data_out1_com_buf, data_out2_com_buf, data_out3_com_buf;
reg [1:0] code_in_com;

//variables for track_trellis
reg start_track;
reg [1:0] node, next_node, node_trk;
wire [1:0] next_node_trk;
reg [1:0] next_node_trk_buf;
wire data_trk, data_out_trk, done_trk;
reg [1:0] flag_trk;

compute_path_metric mod1 (.clk(clk), .rst(rst), .st(start_compute),
						  .code_in(code_in_com),
						  .data_in0(data_in0_com), .data_in1(data_in1_com), 
						  .data_in2(data_in2_com), .data_in3(data_in3_com),
						  .data_out0(data_out0_com), .data_out1(data_out1_com),
						  .data_out2(data_out2_com), .data_out3(data_out3_com),
						  .done(done_compute));


track_trellis mod2 (.clk(clk), .rst(rst), .st(start_track),
					.node(node_trk), .flag(flag_trk), .next_node(next_node_trk),
					.data_out(data_out_trk), .done(done_trk));

always @(posedge clk or posedge rst) 
begin
	if (rst) 
		begin
			// reset
			// base_addr <= 1;
			// cnt_test <= 0;
			state <= start;
			// node <= 2'b00;
		end
	else
		begin
			state <= next_state;
			// node <= next_node;
		end
end

always @*
begin
	next_state = state;
	case (state)
		start:
			begin
				done_comp_test = 1'b0;
				RAM[0] = 7'b0;
				RAM[1] = 7'b0;
				RAM[2] = 7'b0;
				RAM[3] = 7'b0;
				base_addr = 0;
				if(st) 
					begin
						dataInReg[0] = code_in[1:0];
						dataInReg[1] = code_in[3:2];
						dataInReg[2] = code_in[5:4];
						dataInReg[3] = code_in[7:6];
						dataInReg[4] = code_in[9:8];
						dataInReg[5] = code_in[11:10];
						dataInReg[6] = code_in[13:12];
						dataInReg[7] = code_in[15:14];
						dataInReg[8] = code_in[17:16];
						dataInReg[9] = code_in[19:18];
						next_state = compute;
					end
				else 
					next_state = start;
				done = 1'b0;
			end
		compute:
			begin
				code_in_com = dataInReg[base_addr];
				data_in_test = code_in_com;
				data_in0_com = RAM[(base_addr)*4];
				data_in1_com = RAM[(base_addr)*4 + 1];
				data_in2_com = RAM[(base_addr)*4 + 2];
				data_in3_com = RAM[(base_addr)*4 + 3];

				ram_test0 = RAM[base_addr*4];
				ram_test1 = RAM[(base_addr)*4 + 1];
				ram_test2 = RAM[(base_addr)*4 + 2];
				ram_test3 = RAM[(base_addr)*4 + 3];
				start_compute = 1'b1;

				if (done_compute) 
					begin						
						data_out0_com_buf = data_out0_com;
						data_out1_com_buf = data_out1_com;
						data_out2_com_buf = data_out2_com;
						data_out3_com_buf = data_out3_com;
						base_addr = base_addr + 1;
						next_state = store;
					end
				else 
					next_state = compute;
				if (base_addr == 9) 
					next_state = tracking;
			end
		store:
			begin
				start_compute = 1'b0;
				cnt_test = cnt_test + 1;
				if (base_addr == 0)
					begin
						RAM[0] = 0;
						RAM[1] = 0;
						RAM[2] = 0;
						RAM[3] = 0;
						// next_state = compute;
					end

				else if (base_addr == 1)
					begin
						RAM[4] = data_out0_com;
						RAM[5] = 7'b0;
						RAM[6] = data_out2_com;
						RAM[7] = 7'b0;
						//base_addr = base_addr + 1;
						// next_state = compute;
					end
				else 
					begin
						RAM[base_addr*4] = data_out0_com_buf;
						RAM[base_addr*4 + 1] = data_out1_com_buf;
						RAM[base_addr*4 + 2] = data_out2_com_buf;
						RAM[base_addr*4 + 3] = data_out3_com_buf;
						// next_state = compute;			
					end	
				next_state = compute;			
			end
		tracking:
			begin
				if(base_addr == 9)
					begin
						node_trk = minimum_metric(RAM[MAXIMUM_LENGTH_CODE*4][6:2], 
										   	RAM[MAXIMUM_LENGTH_CODE*4 + 1][6:2],
										   	RAM[MAXIMUM_LENGTH_CODE*4 + 2][6:2],
										   	RAM[MAXIMUM_LENGTH_CODE*4 + 3][6:2]);
					end
				else 
					begin
						node_trk = next_node;
					end
				if (base_addr == 15)
					begin
						next_state = finish;						
					end
				else 
					begin
						if (node_trk == 2'b00)
							flag_trk = RAM[base_addr*4][1:0];
						else if (node_trk == 2'b01)
							flag_trk = RAM[base_addr*4 + 1][1:0];
						else if (node_trk == 2'b10)
							flag_trk = RAM[base_addr*4 + 2][1:0];
						else if (node_trk == 2'b11)
							flag_trk = RAM[base_addr*4 + 3][1:0];
						next_state = decode;
					end
			end
		decode:
			begin
				if (node_trk == 2'b00)
					flag_trk = RAM[base_addr*4][1:0];
				else if (node_trk == 2'b01)
					flag_trk = RAM[base_addr*4 + 1][1:0];
				else if (node_trk == 2'b10)
					flag_trk = RAM[base_addr*4 + 2][1:0];
				else if (node_trk == 2'b11)
					flag_trk = RAM[base_addr*4 + 3][1:0];
				dataout_reg[base_addr] = data_out_trk;
				data_out_trk_test = data_out_trk;
				next_node = next_node_trk;
				base_addr = base_addr - 1;
				next_state = tracking;
			end
		finish:
			begin
				done = 1'b1;
				next_state = start;	
			end
	endcase

end

assign state_test = state;
assign data_out = {dataout_reg[9],dataout_reg[8],dataout_reg[7],dataout_reg[6],
				   dataout_reg[5],dataout_reg[4],dataout_reg[3],dataout_reg[2],
				   dataout_reg[1],dataout_reg[0]};
assign node_test = node_trk;
assign base_addr_test = base_addr;
assign done_compute_test =  done_compute;
assign done_trk_test = done_trk;
assign flag_trk_test = flag_trk;
endmodule

