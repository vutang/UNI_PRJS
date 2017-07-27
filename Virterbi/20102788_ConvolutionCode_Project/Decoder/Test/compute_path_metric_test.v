module compute_path_metric_test;

reg clk, rst, st;
reg [1:0] code_in;
reg [7:0] data_in0, data_in1, data_in2, data_in3;

wire [7:0] data_out0, data_out1, data_out2, data_out3;
wire [1:0] state_test;
wire done;

compute_path_metric xxx (.clk(clk), .rst(rst), .st(st),
						 .code_in(code_in), 
						 .data_in0(data_in0), .data_in1(data_in1),
						 .data_in2(data_in2), .data_in3(data_in3),
						 .data_out0(data_out0), .data_out1(data_out1), 
						 .data_out2(data_out2), .data_out3(data_out3),
						 .state_test(state_test),
						 .done(done));



initial
begin
	clk = 1'b0;
	forever #5 clk = ~clk;
end

initial 
begin
	rst = 1'b0;
	#3 rst = 1'b1;
	#4 rst = 1'b0;
end

initial
begin
	st = 1'b0;
	#13 st = 1'b1;
end

initial
begin
	data_in0 = 0;
	data_in1 = 0;
	data_in2 = 0;
	data_in3 = 0;
	code_in = 2'b11;
end

endmodule
