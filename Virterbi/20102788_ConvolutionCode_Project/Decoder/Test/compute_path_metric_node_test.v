module compute_path_metric_node_test;

reg clk, rst, st;
reg [4:0] pre_metric1, pre_metric2, pre_metric3, pre_metric0;
reg [1:0] bm0_1, bm0_2, bm1_1, bm1_2, bm2_1, bm2_2, bm3_1, bm3_2;

wire [7:0] data1, data2, data3, data0;
wire done;

compute_path_metric_node xxx (.clk(clk), .rst(rst), .st(st), 
			.pre_metric0(pre_metric0), .pre_metric1(pre_metric1),
			.pre_metric2(pre_metric2), .pre_metric3(pre_metric3),
			.bm0_1(bm0_1), .bm0_2(bm0_2), .bm1_1(bm1_1), .bm1_2(bm1_2),
			.bm2_1(bm2_1), .bm2_2(bm2_2), .bm3_1(bm3_1), .bm3_2(bm3_2),
			.data0(data0), .data1(data1), .data2(data2), .data3(data3),
			.done(done));

initial
begin
	clk = 1'b0;
	forever #5 clk = ~ clk;
end

initial 
begin
	rst = 1'b0;
	#3 rst = 1'b1;
	#4 rst = 1'b0;
end

initial
begin
	pre_metric0 = 0;
	pre_metric2 = 0;
	pre_metric1 = 0;
	pre_metric3 = 0;
	#13;
	{bm0_1, bm0_2} = 4'b0001;
	{bm1_1, bm1_2} = 4'b0001;
	{bm2_1, bm2_2} = 4'b0001;
	{bm3_1, bm3_2} = 4'b0001;
	st = 1'b1; #10;
	st = 1'b0; #5; 
	pre_metric0 = data0;
	pre_metric1 = data1;
	pre_metric2 = data2;
	pre_metric3 = data3;
	#30;
	
	{bm0_1, bm0_2} = 4'b1110;
	{bm1_1, bm1_2} = 4'b1110;
	{bm2_1, bm2_2} = 4'b1110;
	{bm3_1, bm3_2} = 4'b1110;
	st = 1'b1;
end
endmodule