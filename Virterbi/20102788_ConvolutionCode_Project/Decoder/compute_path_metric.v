module compute_path_metric
(
	input clk, rst, st,
	input [1:0] code_in,
	input [7:0]  data_in0, data_in1, data_in2, data_in3,
	output reg [7:0] data_out0, data_out1, data_out2, data_out3,
	output  done,
	output [1:0] state_test
);


// have about 10 column (each column has 4 nodes) in trellis
// -maximum metric path = 20 -> 5 bit
// -flag for 2 path each nodes -> 2 bit
// -> we need 7 bit data then we will use 8 bit.

// we have 10*4 = 40 nodes so we need use log2(40) + 1 = 6 bit for address
parameter DATA_WIDTH = 8,
		  ADDR_WIDTH = 6;

//Store trellis information

parameter  start = 0,
		   compute_branch_metric = 1,
		   compute_path_metric = 2,
		   finish = 3;
reg [1:0] state, next_state;

//declaring signals for hamming_distance_state module
reg start_compute_bm;
wire done_compute_bm;
reg [1:0] data_in_bm;
wire [3:0] node0_bm, node2_bm, node3_bm, node1_bm;						//node's branch metric
reg [3:0] node0_bm_buf, node2_bm_buf, node3_bm_buf, node1_bm_buf;
//declaring signals for compute_metric_path module
reg start_compute_pm;
wire done_compute_pm;
reg [4:0] pm0, pm1, pm2, pm3;											//pm ~ pre-metricpath
reg [3:0] bm0, bm1, bm2, bm3;											//bm ~ branch metric
wire [7:0] m0, m1, m2, m3;												//present metric + flag

// reg [1:0] hold;

hamming_distance_state #(.CODE_WIDTH(2)) mod1 (.clk(clk), .rst(rst), .st(start_compute_bm),
											   .data_in(data_in_bm), 
											   .node0(node0_bm), .node1(node1_bm), 
											   .node2(node2_bm), .node3(node3_bm),
											   .done(done_compute_bm));	//bm ~ branch metric

compute_path_metric_node mod2 (.clk(clk), .rst(rst), .st(start_compute_pm),
						  .pre_metric1(pm1), .pre_metric2(pm2),
						  .pre_metric3(pm3), .pre_metric0(pm0), 
						  .bm0_1(bm0[1:0]), .bm0_2(bm0[3:2]),
						  .bm1_1(bm1[1:0]), .bm1_2(bm1[3:2]),
						  .bm2_1(bm2[1:0]), .bm2_2(bm2[3:2]),
						  .bm3_1(bm3[1:0]), .bm3_2(bm3[3:2]),
						  .data0(m0), .data1(m1), .data2(m2),
						  .data3(m3), .done(done_compute_pm));			//pm ~ path metric

always @(posedge clk) 
begin
	if (rst) 
		begin
			// reset
			state <= start;
			// hold <= 0;
			//done <= 1'b0;
		end
	else
		begin
			state <= next_state;
		end
end

always @*
begin
	next_state = state;
	case(state)
		start:
			begin
				start_compute_bm = 1'b0;
				start_compute_pm = 1'b0;
				if (st)
					next_state = compute_branch_metric;
				else
					next_state = start;
			end
		compute_branch_metric:
			begin			
				data_in_bm = code_in;
				node0_bm_buf = node0_bm;
				node1_bm_buf = node1_bm;
				node2_bm_buf = node2_bm;
				node3_bm_buf = node3_bm;
				next_state = compute_path_metric;
			end
		compute_path_metric:
			begin
				pm0 = data_in0[6:2];
				pm1 = data_in1[6:2];
				pm2 = data_in2[6:2];
				pm3 = data_in3[6:2];
				bm0 = node0_bm_buf;
				bm1 = node1_bm_buf;
				bm2 = node2_bm_buf;
				bm3 = node3_bm_buf;

				data_out0 = m0;
				data_out1 = m1;
				data_out2 = m2;
				data_out3 = m3;
				next_state = finish;
			end
		finish:
			begin
				next_state = start;
			end
	endcase
end

assign state_test = state;

assign done = (state == finish)? 1'b1 : 1'b0;

endmodule

