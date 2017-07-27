module track_trellis_test;
reg clk, rst, st;
reg [1:0] node, flag;
wire [1:0] next_node;
wire data_out;
wire done;

reg [1:0] index;

track_trellis xxx (.clk(clk), .rst(rst), .st(st), .node(node), .flag(flag),
				   .next_node(next_node), .data_out(data_out), .done(done));

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
	#13 st = 1;
	for (index = 0; index < 4; index = index + 1)
		begin
			node = index;
			flag = 2'b00; #50;
			flag = 2'b01; #50;
			flag = 2'b10; #50;
			flag = 2'b11; #50;
		end
end

endmodule