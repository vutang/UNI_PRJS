module ViterbiDecoder_test;
	
	reg clk, rst, st;
	//reg [1:0] code_in;
	wire [9:0] data_out;
	wire done;
	reg [1:0] code_in_reg [9:0];
	wire [19:0] connect;
	//wire [6:0] ram_test0, ram_test1, ram_test2, ram_test3;
	wire [4:0] metric0, metric1, metric2, metric3;
	wire [1:0] flag0, flag1, flag2, flag3;
	wire [1:0] data_in_test;
	wire done_comp_test, done_compute_test, done_trk_test;
	wire [2:0] state_test;
	reg [3:0] index;
	wire [1:0] node_test;
	wire [3:0] base_addr_test;
	wire [4:0] cnt_test;
	wire data_out_trk_test;
	wire [1:0] flag_trk_test;

	ViterbiDecoder #(9) xxx (.clk(clk), .rst(rst), .st(st), 
				.code_in(connect), 
				.ram_test0({metric0,flag0}), .ram_test1({metric1,flag1}), 
				.ram_test2({metric2,flag2}), .ram_test3({metric3,flag3}), 
				.done_comp_test(done_comp_test),
				.data_in_test(data_in_test), .state_test(state_test), .node_test(node_test),
				.base_addr_test(base_addr_test), .cnt_test(cnt_test),
				.done_compute_test(done_compute_test), .done_trk_test(done_trk_test),
				.data_out_trk_test(data_out_trk_test),
				.flag_trk_test(flag_trk_test),
						.data_out(data_out), .done(done));

	assign connect ={code_in_reg[9],code_in_reg[8],code_in_reg[7],
						  code_in_reg[6],code_in_reg[5],code_in_reg[4],
						  code_in_reg[3],code_in_reg[2],code_in_reg[1],
						  code_in_reg[0]} ;

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
		$readmemb("encoded_bits.txt",code_in_reg);
		index = 0;
		st = 1'b0;
		#13 st = 1'b1;
		#10 st = 1'b0;
	end
endmodule


