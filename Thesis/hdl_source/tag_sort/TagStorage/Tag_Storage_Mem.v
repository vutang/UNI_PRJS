//------------------------------------------------------------
// Author			:	vantubk
// Edit				: 	vutangbk
// Date				:	2015-04-16 15:30:09
// Last Modified 	:	2015-06-06 16:47:29
// Description		:	Sua lai toan bo
// 						new idea: 2 chu ki doc, 2 chu ki ghi tre 2clk sau chu ki doc
// 						dung 2 thanh ghi dem gia tri ghi truoc
//------------------------------------------------------------
module  Tag_Storage_Mem 
#(
	parameter 	TAG_VALUE_WIDTH 		= 12,			// number of bit in tag value
	parameter 	PCK_ID_WIDTH 			= 13, 			// Packet ID
	parameter 	SPB_ADDR_WIDTH 			= 8, 			// number of bit in SPB addr	
	parameter 	TAG_STORAGE_ADDR_WIDTH 	= 13 			// number of bit in storage mem addr
) 
(
	input 										clk,    		// Clock
	input 										rst,
	input 		[TAG_STORAGE_ADDR_WIDTH-1:0] 	ipointer,		// Tag Address in Tag Storage
	input 		[TAG_VALUE_WIDTH-1:0] 	 		i_tag_value,	// Tag Value
	input 		[PCK_ID_WIDTH-1:0] 				i_pack_id,		// Package ID
	input 		[SPB_ADDR_WIDTH-1:0]			i_pack_addr,	// Packet Address in SPB
	input 										wr_req,
	input 										rd_req,

	output reg 	[SPB_ADDR_WIDTH-1:0] 			op_addr_of_min_tag,	// Minimum Tag ~ Package Address in SPB
	output reg 	[TAG_VALUE_WIDTH-1:0] 			op_tag_del,				// Need Delete Node (signals for Trie)
	output reg 	[PCK_ID_WIDTH-1:0] 				op_pak_id,
	output wire	[TAG_STORAGE_ADDR_WIDTH-1:0]	op_addr_update,			// update Translation Table 
	output wire [TAG_VALUE_WIDTH-1:0]			op_tag_update,				// update Translation Table
	output wire 								wr_done

	// output reg	[TAG_STORAGE_ADDR_WIDTH-1:0] 	head_emptylist_test,
	// output reg 	[TAG_STORAGE_ADDR_WIDTH-1:0] 	head_emptylist_buf_test
);
	// internal parameters
	// | tag value |packet id| package address |      pointer        |
	// |<----T---->|<---I--->|<--S------------>|<--M---------------->|
	parameter 	TAG_STORAGE_DATA_WIDTH = TAG_VALUE_WIDTH + PCK_ID_WIDTH 
										+ SPB_ADDR_WIDTH + TAG_STORAGE_ADDR_WIDTH;
	// write state
	parameter W_READ_1     	= 2'd0;
	parameter W_READ_2     	= 2'd1;
	parameter W_WRITE_IDLE  = 3'd0;
	parameter W_WRITE_1    	= 3'd1;
	parameter W_WRITE_2     = 3'd2;

	// read state
	parameter R_IDLE 	= 3'd0;
	parameter R_1 		= 3'd1;
	parameter R_2 		= 3'd2;

	// internal variables
	reg [1:0] 			w_read_state;
	reg [2:0] 			w_write_state;
	reg	[2:0] 			r_state;

	reg 	[TAG_STORAGE_ADDR_WIDTH:0] 		counter;
	reg 	[TAG_STORAGE_ADDR_WIDTH-1:0] 	head_emptylist, head_emptylist_buf;
	reg 	[TAG_STORAGE_ADDR_WIDTH-1:0] 	head_emptylist_b1, head_emptylist_b2;
	reg 	[TAG_STORAGE_DATA_WIDTH-1:0] 	head_datalist;
	reg 	[TAG_STORAGE_ADDR_WIDTH-1:0] 	r_addr2, w_addr;
	reg		[TAG_STORAGE_ADDR_WIDTH-1:0] 	ipointer_b1,ipointer_b2;
	// reg 	[TAG_STORAGE_ADDR_WIDTH-1:0] 	r_addr1;
	wire 	[TAG_STORAGE_ADDR_WIDTH-1:0] 	r_addr1;
	reg 	[TAG_STORAGE_DATA_WIDTH-1:0] 	w_data;
	reg 	[TAG_STORAGE_DATA_WIDTH-1:0] 	r_data1_b, r_data1_b2;
	reg		[TAG_VALUE_WIDTH-1:0] 	 		i_tag_value_b1, i_tag_value_b2;	// Tag Value
	reg		[PCK_ID_WIDTH-1:0] 				i_pack_id_b1, i_pack_id_b2;		// Package ID
	reg		[SPB_ADDR_WIDTH-1:0]			i_pack_addr_b1, i_pack_addr_b2;
	wire 								 	wr_en;
	reg 									wr_req_b;
	wire 	[TAG_STORAGE_DATA_WIDTH-1:0] 	r_data1, r_data2, r_data1_mod;
	reg 	[TAG_STORAGE_ADDR_WIDTH-1:0]	op_addr_update_buf;
	reg 	[TAG_VALUE_WIDTH-1:0]			op_tag_update_buf;	

	Dualport_Bram_Tagsort_Mem 
		#(.N(TAG_STORAGE_ADDR_WIDTH), .B(TAG_STORAGE_DATA_WIDTH)) 
		Dualport_Bram_Tagsort_Mem
		(
			.clk 			(clk),
			.wr_en 			(wr_en),
			.r_addr1 		(r_addr1),	
			.r_data1 		(r_data1),
			.w_addr 		(w_addr),	
			.w_data 		(w_data),
			.r_addr2 		(r_addr2),	
			.r_data2	   	(r_data2)			
		);
	//-------------------mod-------------------
	assign r_addr1 = (w_read_state == W_READ_1)? head_emptylist:ipointer;
	// assign wr_en = (w_write_state == W_WRITE_IDLE)?1'b0:1'b1;
	assign wr_en = 1;
	//
	assign wr_done = (w_read_state == W_READ_2)? 1'b1:1'b0;
	assign op_tag_update = i_tag_value;
	assign  op_addr_update = head_emptylist;
	//-------------------write data-------------------
	//neu cay chua co du lieu, can ghi 15 vao cay
	//-----doan tren k can thiet nua, theo t doc thi c da xet truong hop
	//cay empty r thi phai???????---------------- neu can thi co wire tree_empty
	//de xu li
	//
	// vi du: 15->17, chen 16 vao giua
	// b1: doc head_emptylist. co pointer_empty
	// b2: doc noi dung o nho 15, co pointer17
	// b3: ghi data+17_pointer vao head_emptylist
	// b4: ghi 15+head_emptylist vao pointer15, cap nhat head_emptylist
	//
	// emptylist luc dau duoc khoi tao trong Dualport_Bram_Tagsort_Mem
	// sao cho toan bo bo nho la emptylist. head_emptylist co dia chi la 0
	always @(posedge clk) begin
		if(rst) begin
			w_read_state <= W_READ_1;
			w_write_state <= W_WRITE_IDLE;
			counter <= 1;
			head_emptylist <= 1;
			head_emptylist_buf <= 0;
			// op_addr_update <= 0;
			// op_tag_update <= 0;
			// wr_done <= 0;
		end
		else 
		//--------------------------------------
		case (w_read_state)
			W_READ_1: begin 				//read 1
				if(wr_req) begin 
					w_read_state <= W_READ_2;
				end
				// wr_done <= 0;
			end
			W_READ_2: begin 					//read 2
				head_emptylist <= r_data1[TAG_STORAGE_ADDR_WIDTH-1:0];
				head_emptylist_b1 <= head_emptylist;
				head_emptylist_b2 <= head_emptylist_b1;
				// buffer
				i_tag_value_b1 <= i_tag_value;
				i_pack_id_b1 <= i_pack_id;
				i_pack_addr_b1 <= i_pack_addr;
				i_tag_value_b2 <= i_tag_value_b1;
				i_pack_id_b2 <= i_pack_id_b1;
				i_pack_addr_b2 <= i_pack_addr_b1;
				ipointer_b1 <= ipointer;
				ipointer_b2 <= ipointer_b1;
				//
				w_read_state <= W_READ_1;			
			end
		endcase
		//--------------------------------------
		case (w_write_state)
			W_WRITE_IDLE: begin 
				if (wr_req_b) begin 
					w_write_state <= W_WRITE_1;
				end
			end
			W_WRITE_1: begin 					//------------ 5
		 		w_addr <= head_emptylist_b1;
		 		// w_data <= {i_tag_value_b1, i_pack_id_b1, i_pack_addr_b1, r_data1[TAG_STORAGE_ADDR_WIDTH-1:0]};
		 		w_data <= {i_tag_value_b1, i_pack_id_b1, i_pack_addr_b1, 
			 		(ipointer_b1 == head_emptylist_b2)? 
						 		r_data1_b[TAG_STORAGE_ADDR_WIDTH-1:0]:
						 		(ipointer_b1 == ipointer_b2)? head_emptylist_b2:
						 		r_data1[TAG_STORAGE_ADDR_WIDTH-1:0]
		 		};
		 		// backup data from ipointer
		 		r_data1_b <= r_data1;
		 		r_data1_b2 <= r_data1_b;
				w_write_state <= W_WRITE_2; 
			end			
			W_WRITE_2: begin 					//------------ 7
				w_addr <= ipointer_b1;
				// w_data <= {r_data1_b[TAG_STORAGE_DATA_WIDTH-1:TAG_STORAGE_ADDR_WIDTH], head_emptylist_b1};
				w_data <= {		(ipointer_b1 == head_emptylist_b2)? {i_tag_value_b2, i_pack_id_b2, i_pack_addr_b2}:
						 		(ipointer_b1 == ipointer_b2)? r_data1_b2[TAG_STORAGE_DATA_WIDTH-1:TAG_STORAGE_ADDR_WIDTH]:
						 		r_data1_b[TAG_STORAGE_DATA_WIDTH-1:TAG_STORAGE_ADDR_WIDTH]
					, head_emptylist_b1};
				//-------------------
				//
				if(wr_req_b) begin 
					w_write_state <= W_WRITE_1;
				end
				else begin 
					w_write_state <= W_WRITE_IDLE;
				end
			end	
			default : /* default */;
		endcase
	end
	//-------------------wr req buffer-------------------
	always @(posedge clk) begin 
		wr_req_b <= wr_req;
	end
	//-------------------read data-------------------
	always @(posedge clk) begin
		if(rst) begin 
			r_state <= R_IDLE;
			head_datalist <= 0;
			op_addr_of_min_tag <= 0;
			op_tag_del <= 0;
			op_pak_id <= 0;
		end
		else 
		case (r_state)
			R_IDLE: begin 
				if(rd_req) begin 
					r_addr2 	<= head_datalist[TAG_STORAGE_ADDR_WIDTH-1:0];
					r_state 	<= R_1;
				end 
			end
			R_1: begin  
				r_state <= R_2;
			end 
			R_2: begin  
				op_addr_of_min_tag  <= r_data2[TAG_STORAGE_ADDR_WIDTH+SPB_ADDR_WIDTH-1:TAG_STORAGE_ADDR_WIDTH];
				op_pak_id 	<= r_data2[PCK_ID_WIDTH+TAG_STORAGE_ADDR_WIDTH+SPB_ADDR_WIDTH-1:TAG_STORAGE_ADDR_WIDTH+SPB_ADDR_WIDTH];
				op_tag_del 	<= r_data2[TAG_STORAGE_DATA_WIDTH-1:PCK_ID_WIDTH+TAG_STORAGE_ADDR_WIDTH+SPB_ADDR_WIDTH];
				head_datalist 	<= r_data2;
				r_state <= R_IDLE;
			end
			default : /* default */;
		endcase 
	end
endmodule