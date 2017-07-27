module hamming_distance_state_test;

reg clk, rst, st;
reg [1:0] data_in;
wire [3:0] node0, node1, node2, node3;
reg [1:0] n00, n01, n10, n11, n20, n21, n30, n31;
wire done;


reg [1:0] index;


hamming_distance_state xxx(.clk(clk), .rst(rst), .st(st), .data_in(data_in), 
						   .node0(node0), .node1(node1),
						   .node2(node2), .node3(node3), 
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
	#3 rst = 1'b0;
end

initial
begin
	//done = 1'b0;
	#12;
/*	for (index = 0; index < 3; index = index + 1)
		begin
			data_in = index;
			st = 1'b1;
			while (~done)
			begin
				
			end
				
					{n00,n01} = node0;
					{n10,n11} = node1;
					{n20,n21} = node2;
					{n30,n31} = node3;
				
			#20 st = 1'b0;
		end*/
	data_in = 0; #1;
	st = 1'b1; #3;
	st = 1'b0; #40;
	data_in = 1; #1;
	st = 1'b1; #10;
	st = 1'b0;
	
end

endmodule
	