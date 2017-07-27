// Test Table and Strorage
module Tag_Storage_tb
#(
	parameter 				T = 6,		// number of bit in tag value
	parameter 				S = 6, 		// number of bit in SPB addr
	parameter 				M = 4, 		// number of bit in storage mem addr
	parameter 				I = 6 		// number of bit in Packet ID		
);
	
	reg 			clk, rst;
	reg 			ena, ena_buf;
	reg 			pck_addr_req;
	reg [T-1:0]		matching_tag;
	reg [T-1:0] 	incoming_tag, incoming_tag_buf;
	reg [I-1:0] 	i_pck_id, pck_id_buf;
	reg [S-1:0]		i_pck_spb_addr, pck_spb_addr_buf;

	wire [M-1:0]	ipointer_for_storage_fr_table;
	wire [T-1:0]	op_tag_update_fr_storage;
	wire [M-1:0]	op_addr_update_fr_storage;
	wire 			wr_done;
	wire [S-1:0]	pck_addr;
	wire [I-1:0] 	pck_id;
	wire [T-1:0]	del_node;

	wire [M-1:0] 	head_emptylist_test, head_emptylist_buf_test;

	// Generate clk signal
	initial begin
		clk = 1'b0; forever #5 clk = ~clk;
	end

	// Generate rst signal
	initial	begin
		rst = 1'b0;
		#3 rst = 1'b1;	#10 rst = 1'b0;
	end

	// Table
	Trans_Table 
			#(.N(T), .W(M))
			Trans_Table(
				.clk 				(clk),
				.rst 				(rst),

				.rd_req 			(ena),
				.rd_addr 			(matching_tag),
				.rd_data 			(ipointer_for_storage_fr_table),
				
				.wr_req 			(wr_done),
				.wr_addr 			(op_tag_update_fr_storage),
				.wr_data 			(op_addr_update_fr_storage)		
			);

	// Reg
	always @(posedge clk) begin
		if (rst) begin
			incoming_tag_buf <= 0;
			pck_id_buf <= 0;
			pck_spb_addr_buf <= 0;
			ena_buf <= 0;
		end
		else if (ena) begin
			incoming_tag_buf <= incoming_tag;
			pck_id_buf <= i_pck_id;
			pck_spb_addr_buf <= i_pck_spb_addr;
			ena_buf <= 1'b1;
		end 
		else begin
			ena_buf <= 1'b0;
		end
	end

	// Storage
	Tag_Storage_Mem#(
				.TAG_VALUE_WIDTH 		(T), 
				.PCK_ID_WIDTH 			(I), 
				.SPB_ADDR_WIDTH 		(S), 
				.TAG_STORAGE_ADDR_WIDTH (M)
				)
			Tag_Storage_Mem(
				.clk 			(clk),
				.rst 			(rst),

				.ipointer 		(ipointer_for_storage_fr_table),
				.i_tag_value	(incoming_tag_buf),
				.i_pack_id 		(pck_id_buf),
				.i_pack_addr	(pck_spb_addr_buf),			
				.wr_req 		(ena_buf),
				.rd_req 		(pck_addr_req),
				//output
				.op_addr_of_min_tag		(pck_addr),
				.op_tag_del				(del_node),
				.op_pak_id 				(pck_id),
				.op_addr_update 		(op_addr_update_fr_storage),
				.op_tag_update			(op_tag_update_fr_storage),			
				.wr_done 				(wr_done),

				.head_emptylist_test 	(head_emptylist_test),
				.head_emptylist_buf_test(head_emptylist_buf_test)
			);

	integer read_cnt, write_cnt;
	integer i;
	initial begin
		ena <= 0; pck_addr_req <= 0; read_cnt <= 0; write_cnt <= 1; #14;
		
		ena <= 1; write_cnt <= write_cnt + 1; 
		matching_tag <= 0;	incoming_tag <= 0;	i_pck_id <= 0;	i_pck_spb_addr <= 0; #10; 
		ena <= 0; #70;

		ena <= 1; write_cnt <= write_cnt + 1;
		matching_tag <= 0;	incoming_tag <= 1;	i_pck_id <= 1;	i_pck_spb_addr <= 1; #10; 
		ena <= 0; #70;

		ena <= 1; write_cnt <= write_cnt + 1;
		matching_tag <= 1;	incoming_tag <= 1;	i_pck_id <= 1;	i_pck_spb_addr <= 1; #10; 
		ena <= 0; #70;		

		ena <= 1;
		matching_tag <= 1;	incoming_tag <= 2;	i_pck_id <= 2;	i_pck_spb_addr <= 2; #10; 
		ena <= 0; #70;

		ena <= 1; write_cnt <= write_cnt + 1;
		matching_tag <= 2;	incoming_tag <= 6;	i_pck_id <= 6;	i_pck_spb_addr <= 6; #10; 
		ena <= 0; #70;

		pck_addr_req <= 1; read_cnt = read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("write counter: %d, read counter: %d ----\tpacket address: %d", write_cnt, read_cnt, pck_addr);

		pck_addr_req <= 1; read_cnt = read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("write counter: %d, read counter: %d ----\tpacket address: %d", write_cnt, read_cnt, pck_addr);

		pck_addr_req <= 1; read_cnt = read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("write counter: %d, read counter: %d ----\tpacket address: %d", write_cnt, read_cnt, pck_addr);	

		ena <= 1; write_cnt <= write_cnt + 1;
		matching_tag <= 2;	incoming_tag <= 4;	i_pck_id <= 4;	i_pck_spb_addr <= 4; #10; 
		ena <= 0; #70;

		ena <= 1; write_cnt <= write_cnt + 1;
		matching_tag <= 4;	incoming_tag <= 5;	i_pck_id <= 5;	i_pck_spb_addr <= 5; #10; 
		ena <= 0; #70;

		ena <= 1; write_cnt <= write_cnt + 1;
		matching_tag <= 2;	incoming_tag <= 3;	i_pck_id <= 3;	i_pck_spb_addr <= 3; #10; 
		ena <= 0; #70;

		pck_addr_req <= 1; read_cnt = read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("write counter: %d, read counter: %d ----\tpacket address: %d", write_cnt, read_cnt, pck_addr);

		pck_addr_req <= 1; read_cnt = read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("write counter: %d, read counter: %d ----\tpacket address: %d", write_cnt, read_cnt, pck_addr);

		for (i = 6; i < 15; i = i + 1) begin
			ena <= 1; write_cnt <= write_cnt + 1;
			matching_tag <= i;	incoming_tag <= i + 1;	i_pck_id <= i + 1;	i_pck_spb_addr <= i + 1; #10; 
			ena <= 0; #70;			
		end

		pck_addr_req <= 1; read_cnt = read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("write counter: %d, read counter: %d ----\tpacket address: %d", write_cnt, read_cnt, pck_addr);

		pck_addr_req <= 1; read_cnt = read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("write counter: %d, read counter: %d ----\tpacket address: %d", write_cnt, read_cnt, pck_addr);

		pck_addr_req <= 1; read_cnt = read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("write counter: %d, read counter: %d ----\tpacket address: %d", write_cnt, read_cnt, pck_addr);

		pck_addr_req <= 1; read_cnt = read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("write counter: %d, read counter: %d ----\tpacket address: %d", write_cnt, read_cnt, pck_addr);

		pck_addr_req <= 1; read_cnt = read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("write counter: %d, read counter: %d ----\tpacket address: %d", write_cnt, read_cnt, pck_addr);

		ena <= 1; write_cnt <= write_cnt + 1;
		matching_tag <= 15;	incoming_tag <= 16;	i_pck_id <= 16;	i_pck_spb_addr <= 16; #10; 
		ena <= 0; #70;

		pck_addr_req <= 1; read_cnt = read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("write counter: %d, read counter: %d ----\tpacket address: %d", write_cnt, read_cnt, pck_addr);	

		ena <= 1; write_cnt <= write_cnt + 1;
		matching_tag <= 15;	incoming_tag <= 15;	i_pck_id <= 15;	i_pck_spb_addr <= 15; #10; 
		ena <= 0; #70;


		pck_addr_req <= 1; read_cnt = read_cnt + 1; #10;
		pck_addr_req <= 0; #20;	
		$display("write counter: %d, read counter: %d ----\tpacket address: %d", write_cnt, read_cnt, pck_addr);

		pck_addr_req <= 1; read_cnt = read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("write counter: %d, read counter: %d ----\tpacket address: %d", write_cnt, read_cnt, pck_addr);

		pck_addr_req <= 1; read_cnt = read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("write counter: %d, read counter: %d ----\tpacket address: %d", write_cnt, read_cnt, pck_addr);

		pck_addr_req <= 1; read_cnt = read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("write counter: %d, read counter: %d ----\tpacket address: %d", write_cnt, read_cnt, pck_addr);

		pck_addr_req <= 1; read_cnt = read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("write counter: %d, read counter: %d ----\tpacket address: %d", write_cnt, read_cnt, pck_addr);

		for (i = 16; i < 20; i = i + 1) begin
			ena <= 1; write_cnt <= write_cnt + 1;
			matching_tag <= i;	incoming_tag <= i + 1;	i_pck_id <= i + 1;	i_pck_spb_addr <= i + 1; #10; 
			ena <= 0; #70;
		end // 19 - 20 20 20

		pck_addr_req <= 1; read_cnt = read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("write counter: %d, read counter: %d ----\tpacket address: %d", write_cnt, read_cnt, pck_addr);

		pck_addr_req <= 1; read_cnt = read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("write counter: %d, read counter: %d ----\tpacket address: %d", write_cnt, read_cnt, pck_addr);


		for (i = 19; i < 26; i = i + 1) begin
			ena <= 1; write_cnt <= write_cnt + 1;
			matching_tag <= i;	incoming_tag <= i + 1;	i_pck_id <= i + 1;	i_pck_spb_addr <= i + 1; #10; 
			ena <= 0; 
			pck_addr_req <= 1; read_cnt = read_cnt + 1; #10;
			pck_addr_req <= 0; #20;
			$display("write counter: %d, read counter: %d ----\tpacket address: %d", write_cnt, read_cnt, pck_addr);
			#40;
		end

		// pck_addr_req <= 1; read_cnt = read_cnt + 1; #10;
		// pck_addr_req <= 0; #20;
		// $display("write counter: %d, read counter: %d ----\tpacket address: %d", write_cnt, read_cnt, pck_addr);

		// pck_addr_req <= 1; read_cnt = read_cnt + 1; #10;
		// pck_addr_req <= 0; #20;
		// $display("write counter: %d, read counter: %d ----\tpacket address: %d", write_cnt, read_cnt, pck_addr);

		// pck_addr_req <= 1; read_cnt = read_cnt + 1; #10;
		// pck_addr_req <= 0; #20;
		// $display("write counter: %d, read counter: %d ----\tpacket address: %d", write_cnt, read_cnt, pck_addr);

		// pck_addr_req <= 1; read_cnt = read_cnt + 1; #10;
		// pck_addr_req <= 0; #20;
		// $display("write counter: %d, read counter: %d ----\tpacket address: %d", write_cnt, read_cnt, pck_addr);

		// pck_addr_req <= 1; read_cnt = read_cnt + 1; #10;
		// pck_addr_req <= 0; #20;
		// $display("write counter: %d, read counter: %d ----\tpacket address: %d", write_cnt, read_cnt, pck_addr);	


		for (i = 25; i < 62; i = i + 1) begin
			ena <= 1; write_cnt <= write_cnt + 1;
			matching_tag <= i;	incoming_tag <= i + 1;	i_pck_id <= i + 1;	i_pck_spb_addr <= i + 1; #10; 
			ena <= 0; 
			pck_addr_req <= 1; read_cnt = read_cnt + 1; #10;
			pck_addr_req <= 0; #20;
			$display("write counter: %d, read counter: %d ----\tpacket address: %d", write_cnt, read_cnt, pck_addr);
			#40;
		end

		pck_addr_req <= 1; read_cnt = read_cnt + 1; #10;
		pck_addr_req <= 0; #20;	
		$display("write counter: %d, read counter: %d ----\tpacket address: %d", write_cnt, read_cnt, pck_addr);

		pck_addr_req <= 1; read_cnt = read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("write counter: %d, read counter: %d ----\tpacket address: %d", write_cnt, read_cnt, pck_addr);

		pck_addr_req <= 1; read_cnt = read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("write counter: %d, read counter: %d ----\tpacket address: %d", write_cnt, read_cnt, pck_addr);

		pck_addr_req <= 1; read_cnt = read_cnt + 1; #10;
		pck_addr_req <= 0; #20;
		$display("write counter: %d, read counter: %d ----\tpacket address: %d", write_cnt, read_cnt, pck_addr);

		// pck_addr_req <= 1; read_cnt = read_cnt + 1; #10;
		// pck_addr_req <= 0; #20;
		// $display("write counter: %d, read counter: %d ----\tpacket address: %d", write_cnt, read_cnt, pck_addr);
	end
endmodule 