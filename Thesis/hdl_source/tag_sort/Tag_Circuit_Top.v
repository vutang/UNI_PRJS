module Tag_Circuit_Top
#(
	parameter 				T = 12,		// number of bit in tag value
	parameter 				S = 8, 		// number of bit in SPB addr
	parameter 				M = 4, 		// number of bit in storage mem addr		
	parameter 				I = 4 		// packet ID
)
(
	input wire				clk, rst,

	input wire 				ena1, ena2,
	input wire 	[T-1:0]		incoming_tag,	// new tag
	input wire 				pck_addr_req,	// request read packet addr (storage in SPB)
	input wire 	[I-1:0]		pck_id_in,		// packet ID in 
	input wire 	[S-1:0]		pck_spb_addr_in,	// packet address in SPB in

	output wire [T-1:0]		tag_value_out,
	output wire	[S-1:0]		pck_addr_out,	// packet address in SPB out
	output wire [I-1:0]		pck_id_out,		// packet ID out
	output wire 			wr_done_mem
);

	reg 				ena, ena_buf;
	wire 	[T-1:0]		matching_tag;
	reg 	[T-1:0] 	incoming_tag_buf;
	reg 	[I-1:0] 	i_pck_id, pck_id_buf;
	reg		[S-1:0]		i_pck_spb_addr, pck_spb_addr_buf;

	wire 	[M-1:0]		ipointer_for_storage_fr_table;
	wire 	[T-1:0]		op_tag_update_fr_storage;
	wire 	[M-1:0]		op_addr_update_fr_storage;
	wire 				wr_done;
	wire  	[T-1:0]		del_node;
	wire 	[M-1:0] 	head_emptylist_test, head_emptylist_buf_test;
	wire	[T-1:0] 	incoming_tag_forward;

	reg 	[I-1:0]		pck_id_buf_1, pck_id_buf_2, pck_id_buf_3,
						pck_id_buf_4, pck_id_buf_5, pck_id_buf_6,
						pck_id_buf_7;
	reg 	[S-1:0]		pck_spb_addr_buf_1, pck_spb_addr_buf_2, pck_spb_addr_buf_3, 
						pck_spb_addr_buf_4, pck_spb_addr_buf_5, pck_spb_addr_buf_6, 
						pck_spb_addr_buf_7; 

	// Data Path
	// ---------------------------------------------------
	// Tree
	Multibit_Tree_Top
		#(.T(T))
		Multibit_Tree_Top
		(
			.clk 					(clk),
			.rst 					(rst),
			.ena 					(ena1),
			.incoming_tag 			(incoming_tag),
			.matching_tag 			(matching_tag),
			.incoming_tag_forward 	(incoming_tag_forward)
		);
	always @(posedge clk) begin
		if (rst) begin
			pck_id_buf_1 <= 0;
			pck_id_buf_2 <= 0;
			pck_id_buf_3 <= 0;
			pck_id_buf_4 <= 0;
			pck_id_buf_5 <= 0;
			pck_id_buf_6 <= 0;
			pck_id_buf_7 <= 0;
			i_pck_id 	 <= 0;

			pck_spb_addr_buf_1 <= 0;
			pck_spb_addr_buf_2 <= 0;
			pck_spb_addr_buf_3 <= 0;
			pck_spb_addr_buf_4 <= 0;
			pck_spb_addr_buf_5 <= 0;
			pck_spb_addr_buf_6 <= 0;
			pck_spb_addr_buf_7 <= 0;
			i_pck_spb_addr 	   <= 0;
		end
		else if (ena1) begin
			pck_id_buf_1 <= pck_id_in;
			pck_id_buf_2 <= pck_id_buf_1;
			pck_id_buf_3 <= pck_id_buf_2;
			pck_id_buf_4 <= pck_id_buf_3;
			pck_id_buf_5 <= pck_id_buf_4;
			pck_id_buf_6 <= pck_id_buf_5;
			pck_id_buf_7 <= pck_id_buf_6;
			i_pck_id 	 <= pck_id_buf_7;

			pck_spb_addr_buf_1 <= pck_spb_addr_in;
			pck_spb_addr_buf_2 <= pck_spb_addr_buf_1;
			pck_spb_addr_buf_3 <= pck_spb_addr_buf_2;
			pck_spb_addr_buf_4 <= pck_spb_addr_buf_3;
			pck_spb_addr_buf_5 <= pck_spb_addr_buf_4;
			pck_spb_addr_buf_6 <= pck_spb_addr_buf_5;
			pck_spb_addr_buf_7 <= pck_spb_addr_buf_6;
			i_pck_spb_addr 	   <= pck_spb_addr_buf_7;
		end
	end
	// Table
	Trans_Table 
			#(.N(T), .W(M))
			Trans_Table(
				.clk 				(clk),
				.rst 				(rst),

				.rd_req 			(ena2),
				.rd_addr 			(matching_tag),
				.rd_data 			(ipointer_for_storage_fr_table),
				
				.wr_req 			(wr_done),
				.wr_addr 			(op_tag_update_fr_storage),
				.wr_data 			(op_addr_update_fr_storage)		
			);

	// Reg
	always @(posedge clk) begin
		if (rst) begin
			incoming_tag_buf 	<= 0;
			pck_id_buf 			<= 0;
			pck_spb_addr_buf 	<= 0;
			ena_buf 			<= 0;
		end
		else if (ena2) begin
			incoming_tag_buf 	<= incoming_tag_forward;
			pck_id_buf 			<= i_pck_id;
			pck_spb_addr_buf 	<= i_pck_spb_addr;
			ena_buf 			<= 1'b1;
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
				.clk 					(clk),
				.rst 					(rst),

				.ipointer 				(ipointer_for_storage_fr_table),
				.i_tag_value			(incoming_tag_buf),
				.i_pack_id 				(pck_id_buf),
				.i_pack_addr			(pck_spb_addr_buf),			
				.wr_req 				(ena_buf),
				.rd_req 				(pck_addr_req),
				//output
				.op_addr_of_min_tag		(pck_addr_out),
				.op_pak_id 				(pck_id_out),
				.op_tag_del				(tag_value_out),				
				.op_addr_update 		(op_addr_update_fr_storage),
				.op_tag_update			(op_tag_update_fr_storage),			
				.wr_done 				(wr_done)

				// .head_emptylist_test 	(head_emptylist_test),
				// .head_emptylist_buf_test(head_emptylist_buf_test)
			);
	assign wr_done_mem = wr_done;
	// -------------------------------------------------------

endmodule
