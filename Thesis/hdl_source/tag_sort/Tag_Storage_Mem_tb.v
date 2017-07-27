// Test Storage 
`timescale 1ps / 1ps
module Tag_Storage_Mem_tb 
#(
	parameter T = 4,
	parameter I = 4,
	parameter S = 4,
	parameter M = 4
);
	
	reg 			clk, rst;
	reg 	[M-1:0] ipointer;
	reg 	[T-1:0] idata1;
	reg 	[S-1:0] idata2;
	reg 			wr_req;
	reg 			rd_req;

	wire 	[S-1:0] op_min;
	wire 	[T-1:0] op_del;
	wire 	[M-1:0] op_addr;
	wire 	[T-1:0] op_tag;
	wire 	[I-1:0] op_pak_id;

	wire 			wr_done;

	wire	[M-1:0] head_emptylist;
	wire	[M-1:0] head_emptylist_buf;
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

	Tag_Storage_Mem 
				#(
					.TAG_VALUE_WIDTH		(T),		// Tag has 4 bits
					.PCK_ID_WIDTH			(I), 		// Packet ID
					.SPB_ADDR_WIDTH 		(S),		// SPB has 8 bits in its addr
					.TAG_STORAGE_ADDR_WIDTH	(M)			// Storage has 4 bits in its addr 
				) 
			sim1
				(
					.clk		(clk),
					.rst		(rst),
					.ipointer	(ipointer),
					.i_tag_value(idata1),
					.i_pack_id 	(idata2),
					.i_pack_addr(idata2),
					.wr_req 	(wr_req),
					.rd_req 	(rd_req),

					.op_min		(op_min),
					.op_del 	(op_del),
					.op_pak_id 	(op_pak_id), 
					.op_tag 	(op_tag),
					.op_addr	(op_addr),					
					.wr_done 	(wr_done),

					// test signal 
					.head_emptylist_test (head_emptylist),
					.head_emptylist_buf_test (head_emptylist_buf)
				);

	// test script
	// write process
	integer i, j;
	initial
	begin
		wr_req <= 0;
		#15;
		wr_req <= 1'b1; //1
		ipointer <= 0; idata1<= 1; idata2 <= 1;	#10;
		wr_req <= 0; #110;
		$display("Write: %d-ipointer:\t%d\t-head emptylist:\t%d\t-head emptylist buf: \t%d", i, ipointer, head_emptylist, head_emptylist_buf);
		for (i = 1; i < 14; i = i + 1) begin
			wr_req <= 1;
			ipointer <= i; idata1 <= i + 1; idata2 <= i + 1; #10;	
			wr_req <= 0; #100;
			$display("Write: %d-ipointer:\t%d\t-head emptylist:\t%d\t-head emptylist buf: \t%d", i, ipointer, head_emptylist, head_emptylist_buf);
		end
		wr_req <= 1'b1; //1
		ipointer <= 14; idata1<= 14; idata2 <= 14;	#10;
		wr_req <= 0; #100;
		$display("Write: %d-ipointer:\t%d\t-head emptylist:\t%d\t-head emptylist buf: \t%d", i, ipointer, head_emptylist, head_emptylist_buf);
		
		wr_req <= 1'b1; //1
		ipointer <= 14; idata1<= 14; idata2 <= 14;	#10;
		wr_req <= 0; #100;
		$display("Write: %d-ipointer:\t%d\t-head emptylist:\t%d\t-head emptylist buf: \t%d", i, ipointer, head_emptylist, head_emptylist_buf);
	end
	// read process
	initial begin
		rd_req <= 0;
		#150;
		rd_req <= 1'b1; #19; 	rd_req <= 1'b0;	#21; //1
		$display("Read: \t%d", op_min);
		#600;
		rd_req <= 1'b1; #19; 	rd_req <= 1'b0;	#21; //1
		$display("Read: \t%d", op_min);
		rd_req <= 1'b1; #19; 	rd_req <= 1'b0;	#21; //1
		$display("Read: \t%d", op_min);
		#700;
		rd_req <= 1'b1; #19; 	rd_req <= 1'b0;	#21; //1
		$display("Read: \t%d", op_min);
		rd_req <= 1'b1; #19; 	rd_req <= 1'b0;	#21; //1
		$display("Read: \t%d", op_min);
		rd_req <= 1'b1; #19; 	rd_req <= 1'b0;	#21; //1
		$display("Read: \t%d", op_min);
		rd_req <= 1'b1; #19; 	rd_req <= 1'b0;	#21; //1
		$display("Read: \t%d", op_min);
		rd_req <= 1'b1; #19; 	rd_req <= 1'b0;	#21; //1
		$display("Read: \t%d", op_min);
		rd_req <= 1'b1; #19; 	rd_req <= 1'b0;	#21; //1
		$display("Read: \t%d", op_min);
		rd_req <= 1'b1; #19; 	rd_req <= 1'b0;	#21; //1
		$display("Read: \t%d", op_min);
		rd_req <= 1'b1; #19; 	rd_req <= 1'b0;	#21; //1
		$display("Read: \t%d", op_min);
		rd_req <= 1'b1; #19; 	rd_req <= 1'b0;	#21; //1
		$display("Read: \t%d", op_min);
		rd_req <= 1'b1; #19; 	rd_req <= 1'b0;	#21; //1
		$display("Read: \t%d", op_min);
		rd_req <= 1'b1; #19; 	rd_req <= 1'b0;	#21; //1
		$display("Read: \t%d", op_min);
		rd_req <= 1'b1; #19; 	rd_req <= 1'b0;	#21; //1
		$display("Read: \t%d", op_min);
		rd_req <= 1'b1; #19; 	rd_req <= 1'b0;	#21; //1
		$display("Read: \t%d", op_min);
		rd_req <= 1'b1; #19; 	rd_req <= 1'b0;	#21; //1
		$display("Read: \t%d", op_min);
		

	end

endmodule

		// rd_req <= 1'b1; #19; 	rd_req <= 1'b0;	#11; //1
		// $display("%t: %d", $time, op_min);
		// rd_req <= 1'b1;	#19;	rd_req <= 1'b0;	#11; //2
		// $display("%t: %d", $time, op_min);
		// rd_req <= 1'b1;	#19;	rd_req <= 1'b0;	#11; //3
		// $display("%t: %d", $time, op_min);
		// rd_req <= 1'b1;	#19;	rd_req <= 1'b0;	#11; //4
		// $display("%t: %d", $time, op_min);
		// rd_req <= 1'b1;	#19;	rd_req <= 1'b0;	#11; //5
		// $display("%t: %d", $time, op_min);
		// rd_req <= 1'b1;	#19;	rd_req <= 1'b0;	#11; //6
		// $display("%t: %d", $time, op_min);
		// rd_req <= 1'b1;	#19;	rd_req <= 1'b0;	#11; //7
		// $display("%t: %d", $time, op_min);
		// rd_req <= 1'b1; #19; 	rd_req <= 1'b0;	#11; //8
		// $display("%t: %d", $time, op_min);
		// rd_req <= 1'b1;	#19;	rd_req <= 1'b0;	#11; //9
		// $display("%t: %d", $time, op_min);
		// rd_req <= 1'b1;	#19;	rd_req <= 1'b0;	#11; //10
		// $display("%t: %d", $time, op_min);
		// rd_req <= 1'b1;	#19;	rd_req <= 1'b0;	#11; //11
		// $display("%t: %d", $time, op_min);
		// rd_req <= 1'b1;	#19;	rd_req <= 1'b0;	#11; //12
		// $display("%t: %d", $time, op_min);
		// rd_req <= 1'b1;	#19;	rd_req <= 1'b0;	#11; //13
		// $display("%t: %d", $time, op_min);
		// rd_req <= 1'b1;	#19;	rd_req <= 1'b0;	#11; //14
		// $display("%t: %d", $time, op_min);

		// rd_req <= 1'b1;	#19;	rd_req <= 1'b0;	#11; //15
		// $display("%t: %d", $time, op_min);
		// rd_req <= 1'b1;	#19;	rd_req <= 1'b0;	#11; //16
		// $display("%t: %d", $time, op_min);


		// rd_req <= 1'b1; #19; 	rd_req <= 1'b0;	#11; //1
		// $display("%t: %d", $time, op_min);
		// rd_req <= 1'b1;	#19;	rd_req <= 1'b0;	#11; //2
		// $display("%t: %d", $time, op_min);
		// rd_req <= 1'b1;	#19;	rd_req <= 1'b0;	#11; //3
		// $display("%t: %d", $time, op_min);
		// rd_req <= 1'b1;	#19;	rd_req <= 1'b0;	#11; //4
		// $display("%t: %d", $time, op_min);
		// rd_req <= 1'b1;	#19;	rd_req <= 1'b0;	#11; //5
		// $display("%t: %d", $time, op_min);
		// rd_req <= 1'b1;	#19;	rd_req <= 1'b0;	#11; //6
		// $display("%t: %d", $time, op_min);
		// rd_req <= 1'b1;	#19;	rd_req <= 1'b0;	#11; //7
		// $display("%t: %d", $time, op_min);
		// rd_req <= 1'b1;	#19;	rd_req <= 1'b0;	#11; //8
		// $display("%t: %d", $time, op_min);
		// rd_req <= 1'b1;	#19;	rd_req <= 1'b0;	#11; //9
		// $display("%t: %d", $time, op_min);
		// rd_req <= 1'b1;	#19;	rd_req <= 1'b0;	#11; //10
		// $display("%t: %d", $time, op_min);
		// rd_req <= 1'b1;	#19;	rd_req <= 1'b0;	#11; //11
		// $display("%t: %d", $time, op_min);
		// rd_req <= 1'b1;	#19;	rd_req <= 1'b0;	#11; //12
		// $display("%t: %d", $time, op_min);
		// rd_req <= 1'b1;	#19;	rd_req <= 1'b0;	#11; //13
		// $display("%t: %d", $time, op_min);
		// rd_req <= 1'b1;	#19;	rd_req <= 1'b0;	#11; //14
		// $display("%t: %d", $time, op_min);
		// rd_req <= 1'b1;	#19;	rd_req <= 1'b0;	#11; //15
		// $display("%t: %d", $time, op_min);