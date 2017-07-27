module Multibit_Tree_Top_Tb
#(parameter T = 12);

	reg 				clk, rst;
	reg 				ena;
	reg 	[T-1:0]		incoming_tag;
	// reg 	[11:0]		updating_node;

	wire 	[T-1:0] 	matching_tag;
	wire 	[T-1:0] 	incoming_tag_forward;


	Multibit_Tree_Top 
		#(.T(T))
		sim1
		(
			.clk					(clk), 
			.rst					(rst),
			.ena 					(ena), 
			.incoming_tag 			(incoming_tag),  
			.matching_tag 			(matching_tag),
			.incoming_tag_forward 	(incoming_tag_forward)
		);

	// Generate clk signal
	initial 
	begin
		clk = 1'b0;
		forever #5 clk = ~clk;
	end

	// Generate rst signal
	initial
	begin
		rst = 1'b0;
		#3 rst = 1'b1;
		#10 rst = 1'b0;
	end

	initial
	begin
		ena <= 0; #14;

		// basic test 1
		/*ena <= 0; #10;
		ena <= 1;
		// incoming_tag <= 12'h000; #10; 		// 000
		incoming_tag <= 12'h002; #10; 
		incoming_tag <= 12'h002; #10; 
		incoming_tag <= 12'h003; #10; 
		incoming_tag <= 12'h004; #10;  // da update
		incoming_tag <= 12'h004; #10;
		incoming_tag <= 12'h002; #10;
		incoming_tag <= 12'h001; #10;
		#70;*/
		// pass

		// basic test 2
		/*ena <= 0; #10; 
		ena <= 1;
		incoming_tag <= 12'h102; #10;
		incoming_tag <= 12'h102; #10;
		incoming_tag <= 12'h103; #10;
		incoming_tag <= 12'h104; #10;
		incoming_tag <= 12'h104; #10;
		incoming_tag <= 12'h102; #10;
		incoming_tag <= 12'h101; #10;
		#70;
		// pass*/

		// basic test 3
		/*ena <= 0; #10; 
		ena <= 1;
		incoming_tag <= 12'hf02; #10;
		incoming_tag <= 12'hf02; #10;
		incoming_tag <= 12'hf03; #10;
		incoming_tag <= 12'hf04; #10;
		incoming_tag <= 12'hf04; #10;
		incoming_tag <= 12'hf02; #10;
		incoming_tag <= 12'hf01; #10;
		#70;
		// pass*/

		/*incoming_tag <= 12'h004; #10;
		incoming_tag <= 12'h114; #10;
		incoming_tag <= 12'h112; #10;
		incoming_tag <= 12'h113; #10;*/
		// pass
		
		ena <= 0; #10; 
		ena <= 1;
		incoming_tag <= 12'h004; #10;
		incoming_tag <= 12'h012; #10;
		incoming_tag <= 12'h011; #10;
		incoming_tag <= 12'h013; #10;
		incoming_tag <= 12'h014; #10;
		incoming_tag <= 12'h014; #10;
		incoming_tag <= 12'h012; #10;
		incoming_tag <= 12'h100; #10;
		incoming_tag <= 12'h011; #10;
		incoming_tag <= 12'h0fe; #10;
		incoming_tag <= 12'h0fe; #10;

		ena <= 0; #10; 
		ena <= 1;
		incoming_tag <= 12'h014; #10;
		incoming_tag <= 12'h054; #10;
		incoming_tag <= 12'h064; #10;
		incoming_tag <= 12'h0f4; #10;
		incoming_tag <= 12'h0ff; #10;
		incoming_tag <= 12'h101; #10;
		incoming_tag <= 12'h101; #10;
		incoming_tag <= 12'h01f; #10;
		incoming_tag <= 12'h150; #10;
		incoming_tag <= 12'h000; #10;
		incoming_tag <= 12'h300; #10;
		incoming_tag <= 12'h400; #10;
		incoming_tag <= 12'h151; #10;
		incoming_tag <= 12'ha00; #10;
		incoming_tag <= 12'heee; #10;
		#70; ena <= 0;// pass
		
		// ena <= 0; #10; 
		// ena <= 1;
		// incoming_tag <= 12'h004; #10;
		// incoming_tag <= 12'h012; #10;
		// incoming_tag <= 12'h011; #10;
		// incoming_tag <= 12'h013; #10;
		// incoming_tag <= 12'h013; #10;
		// incoming_tag <= 12'h100; #10;
		// incoming_tag <= 12'h101; #10;
		// incoming_tag <= 12'h014; #10;
		// incoming_tag <= 12'h012; #10;
		// incoming_tag <= 12'h011; #10;
		// incoming_tag <= 12'h0ff; #10;
		// incoming_tag <= 12'h0ff; #10;
		// #70; // pass
		ena <=0;
	end
endmodule