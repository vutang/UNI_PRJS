`timescale 1ns / 1ps
module Tag_Circuit_Top_tb
#(
	parameter 				T = 12,		// number of bit in tag value
	parameter 				S = 13, 		// number of bit in SPB addr
	parameter 				M = 13, 		// number of bit in storage mem addr	
	parameter 				I = 13	
);
	
	reg 			clk, rst;
	reg 			ena1, ena2;
	reg 	[T-1:0] incoming_tag;
	reg 		pck_addr_req;
	reg 	[I-1:0] pck_id_in;
	reg 	[S-1:0]	pck_spb_addr_in;

	wire	[T-1:0]	tag_value_out;
	wire	[S-1:0] pck_addr_out;
	wire 	[I-1:0]	pck_id_out;
	wire 			wr_done_mem;

	Tag_Circuit_Top 
		#(.T(T), .I(I), .S(S), .M(M))
		sim
		(
			.clk 			(clk),
			.rst 			(rst),

			.ena1 			(ena1),
			.ena2 			(ena2),

			.incoming_tag 	(incoming_tag),
			.pck_addr_req 	(pck_addr_req),
			.pck_id_in 		(pck_id_in),
			.pck_spb_addr_in(pck_spb_addr_in),

			.tag_value_out 	(tag_value_out),
			.pck_addr_out 	(pck_addr_out),
			.pck_id_out 	(pck_id_out),
			.wr_done_mem 	(wr_done_mem)
		);	

	// Generate clk signal
	initial begin
		clk = 1'b0;
		forever #5 clk = ~clk;
	end

	// Generate rst signal
	initial	begin
		rst = 1'b0;
		#3 rst = 1'b1;
		#10 rst = 1'b0;
	end

	reg [7:0] rand_delay;
	integer write_cnt = 0, read_cnt = 0;
	integer delay = 100;
	integer i;

	// write process
	initial begin
		ena1 <= 0; ena2 <= 0; 
		// write_cnt = 0;
		#14;

		// flooding
		for (i = 0; i < 8; i = i + 1) begin
			ena1 <= 1; ena2 <= 0; 
			incoming_tag <= 100*i + 1000; pck_id_in <= i + 1; pck_spb_addr_in <= i + 1; #10;
			ena1 <= 0; ena2 <= 0;
			// rand_delay = $random + 6'd90;
			// #rand_delay;
			#10;
		end
		// #60;
		#40;
		ena1 <= 1; ena2 <= 1; 
		incoming_tag <= 900; pck_id_in <= 90; pck_spb_addr_in <= 90; #10;
		ena1 <= 0; ena2 <= 0;
		#10;
		ena1 <= 1; ena2 <= 1; 
		incoming_tag <= 1700; pck_id_in <= 80; pck_spb_addr_in <= 80; #10;
		ena1 <= 0; ena2 <= 0;
		#10;
		ena1 <= 1; ena2 <= 1; 
		incoming_tag <= 700; pck_id_in <= 70; pck_spb_addr_in <= 70; #10;
		ena1 <= 0; ena2 <= 0;
		#10;
		#60;

		for (i = 8; i < 15; i = i + 1) begin
			ena1 <= 1; ena2 <= 1; 
			incoming_tag <=  3000-10*i; pck_id_in <= i + 1; pck_spb_addr_in <= i + 1; #10;
			ena1 <= 0; ena2 <= 0;
			// rand_delay = {$random}%80+ 8'd80;
			// #rand_delay;
			#10; 
			write_cnt = write_cnt + 1;
			$display("write process %d, %d", write_cnt, rand_delay);
		end	
		for (i = 16; i < 50; i = i + 1) begin
			ena1 <= 1; ena2 <= 1; 
			incoming_tag <=  3000-10*i; pck_id_in <= i + 1; pck_spb_addr_in <= i + 1; #10;
			ena1 <= 0; ena2 <= 0;
			// rand_delay = {$random}%80+ 8'd80;
			// #rand_delay;
			#10; 
			write_cnt = write_cnt + 1;
			$display("write process %d, %d", write_cnt, rand_delay);
		end			
	end

	// read process
	initial begin
		pck_addr_req <= 0;
		read_cnt <= 0;

		#260; #80;
		#2400;
		pck_addr_req <= 1; read_cnt <= read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("\t\t%d read process %d:\t%d", $time, read_cnt, pck_addr_out);

		// #140;
		pck_addr_req <= 1; read_cnt <= read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("\t\t%d read process %d:\t%d", $time, read_cnt, pck_addr_out);

		// #2400;
		pck_addr_req <= 1; read_cnt <= read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("\t\t%d read process %d:\t%d", $time, read_cnt, pck_addr_out);

		pck_addr_req <= 1; read_cnt <= read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("\t\t%d read process %d:\t%d", $time, read_cnt, pck_addr_out);

		pck_addr_req <= 1; read_cnt <= read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("\t\t%d read process %d:\t%d", $time, read_cnt, pck_addr_out);

		pck_addr_req <= 1; read_cnt <= read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("\t\t%d read process %d:\t%d", $time, read_cnt, pck_addr_out);

		pck_addr_req <= 1; read_cnt <= read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("\t\t%d read process %d:\t%d", $time, read_cnt, pck_addr_out);

		pck_addr_req <= 1; read_cnt <= read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("\t\t%d read process %d:\t%d", $time, read_cnt, pck_addr_out);

		pck_addr_req <= 1; read_cnt <= read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("\t\t%d read process %d:\t%d", $time, read_cnt, pck_addr_out);

		pck_addr_req <= 1; read_cnt <= read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("\t\t%d read process %d:\t%d", $time, read_cnt, pck_addr_out);	
		#800;
		pck_addr_req <= 1; read_cnt <= read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("\t\t%d read process %d:\t%d", $time, read_cnt, pck_addr_out);

		pck_addr_req <= 1; read_cnt <= read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("\t\t%d read process %d:\t%d", $time, read_cnt, pck_addr_out);

		pck_addr_req <= 1; read_cnt <= read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("\t\t%d read process %d:\t%d", $time, read_cnt, pck_addr_out);	

		pck_addr_req <= 1; read_cnt <= read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("\t\t%d read process %d:\t%d", $time, read_cnt, pck_addr_out);

		pck_addr_req <= 1; read_cnt <= read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("\t\t%d read process %d:\t%d", $time, read_cnt, pck_addr_out);

		pck_addr_req <= 1; read_cnt <= read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("\t\t%d read process %d:\t%d", $time, read_cnt, pck_addr_out);	
		pck_addr_req <= 1; read_cnt <= read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("\t\t%d read process %d:\t%d", $time, read_cnt, pck_addr_out);	
		pck_addr_req <= 1; read_cnt <= read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("\t\t%d read process %d:\t%d", $time, read_cnt, pck_addr_out);	
		pck_addr_req <= 1; read_cnt <= read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("\t\t%d read process %d:\t%d", $time, read_cnt, pck_addr_out);

		pck_addr_req <= 1; read_cnt <= read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("\t\t%d read process %d:\t%d", $time, read_cnt, pck_addr_out);	
		pck_addr_req <= 1; read_cnt <= read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("\t\t%d read process %d:\t%d", $time, read_cnt, pck_addr_out);	
		pck_addr_req <= 1; read_cnt <= read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("\t\t%d read process %d:\t%d", $time, read_cnt, pck_addr_out);	
		pck_addr_req <= 1; read_cnt <= read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("\t\t%d read process %d:\t%d", $time, read_cnt, pck_addr_out);

		pck_addr_req <= 1; read_cnt <= read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("\t\t%d read process %d:\t%d", $time, read_cnt, pck_addr_out);	
		pck_addr_req <= 1; read_cnt <= read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("\t\t%d read process %d:\t%d", $time, read_cnt, pck_addr_out);	
		pck_addr_req <= 1; read_cnt <= read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("\t\t%d read process %d:\t%d", $time, read_cnt, pck_addr_out);	
		pck_addr_req <= 1; read_cnt <= read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("\t\t%d read process %d:\t%d", $time, read_cnt, pck_addr_out);

		pck_addr_req <= 1; read_cnt <= read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("\t\t%d read process %d:\t%d", $time, read_cnt, pck_addr_out);	
		pck_addr_req <= 1; read_cnt <= read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("\t\t%d read process %d:\t%d", $time, read_cnt, pck_addr_out);	
		pck_addr_req <= 1; read_cnt <= read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("\t\t%d read process %d:\t%d", $time, read_cnt, pck_addr_out);	
	end
endmodule
